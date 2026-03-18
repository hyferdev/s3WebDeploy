// terraform/modules/notifications/contact.mjs

import { SESClient, SendEmailCommand } from "@aws-sdk/client-ses";

const ses           = new SESClient({ region: process.env.AWS_REGION });
const SOURCE_EMAIL  = process.env.SOURCE_EMAIL;
const DEST_EMAILS   = process.env.DEST_EMAILS ? process.env.DEST_EMAILS.split(",") : [];
const CONTACT_TOKEN = process.env.CONTACT_TOKEN;

export const handler = async (event) => {
    const headers = {
        "Content-Type": "application/json",
    };

    if (!CONTACT_TOKEN || event.headers?.["x-contact-token"] !== CONTACT_TOKEN) {
        return { statusCode: 401, headers, body: JSON.stringify({ message: "Unauthorized" }) };
    }

    try {
        const body = JSON.parse(event.body);
        const { name, email, company, message, website_url } = body;

        // Honeypot — fake success to confuse bots
        if (website_url) {
            return { statusCode: 200, headers, body: JSON.stringify({ message: "Sent" }) };
        }

        const companyLine = company ? `Company: ${company}\n` : "";

        const command = new SendEmailCommand({
            Source:      SOURCE_EMAIL,
            Destination: { ToAddresses: DEST_EMAILS },
            Message: {
                Subject: { Data: `New Inquiry from ${name}` },
                Body: {
                    Text: {
                        Data: `Name: ${name}\nEmail: ${email}\n${companyLine}\nMessage:\n${message}`
                    }
                }
            }
        });

        await ses.send(command);

        return {
            statusCode: 200,
            headers,
            body: JSON.stringify({ message: "Success" })
        };

    } catch (error) {
        console.error("Contact form error:", error);
        return {
            statusCode: 500,
            headers,
            body: JSON.stringify({ message: "Internal Server Error" })
        };
    }
};
