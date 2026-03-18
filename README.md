# Hyfer - Website

Static site deployed serverlessly on AWS via Terraform and GitHub Actions.

## Stack

- **Frontend**: Static HTML/CSS/JS - no framework
- **CSS**: Tailwind CSS (compiled via CLI)
- **Icons**: Font Awesome 6 (self-hosted)
- **Fonts**: Inter variable font (self-hosted)
- **JS**: esbuild-bundled vendor (AWS SDK)
- **Infrastructure**: AWS S3 + CloudFront + Lambda + SES
- **IaC**: Terraform (Terraform Cloud backend)
- **CI/CD**: GitHub Actions

## Project Structure

```
s3WebDeploy/
├── src/                        # ⚠️ Add your own — not included
│   ├── landing.html            # Main page
│   ├── landing.js              # Must contain REPLACE_WITH_LAMBDA_URL
│   │                           # and REPLACE_WITH_CONTACT_TOKEN placeholders
│   └── ...                     # Any other static assets
├── build/                      # ⚠️ Add your own — not included
│   ├── package.json            # Build dependencies and scripts
│   ├── tailwind.config.js      # Tailwind configuration
│   └── ...
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── modules/
│       ├── storage/            # S3 bucket (private, OAC-only)
│       ├── cdn/                # CloudFront + Route53
│       └── notifications/      # Lambda Function URL + SES contact form
├── .github/workflows/
│   └── deploy.yml              # CI/CD: Terraform → build → S3 sync
└── .gitignore
```

> **Note:** This repo provides the infrastructure and CI/CD pipeline only. You must supply your own `src/` and `build/` directories. The deploy workflow expects:
> - `src/landing.js` to contain the placeholder strings `REPLACE_WITH_LAMBDA_URL` and `REPLACE_WITH_CONTACT_TOKEN` — these are replaced at deploy time with the Terraform outputs.
> - `build/package.json` to define `build` and `watch:css` npm scripts.
> - `build/package-lock.json` for npm caching in CI.

## Local Development

```bash
cd build
npm install
npm run build       # Compile Tailwind CSS + bundle vendor JS
npm run watch:css   # Watch mode for CSS changes
```

Serve `src/` with any static file server:

```bash
npx serve src
```

## Deployment

Deployments are triggered automatically on push to `main` (production) or `staging`. The workflow:

1. Runs Terraform to provision/update AWS infrastructure
2. Injects runtime config (Lambda URL, contact token) into `landing.js`
3. Builds CSS and JS bundles
4. Syncs `src/` to S3

### Required GitHub Secrets

| Secret | Description |
|---|---|
| `TF_API_TOKEN` | Terraform Cloud API token |
| `AWS_ACCESS_KEY_ID` | AWS IAM access key |
| `AWS_SECRET_ACCESS_KEY` | AWS IAM secret key |

### Terraform Cloud Variables

Set these in your Terraform Cloud workspace. Required variables have no default.

| Variable | Type | Sensitive | Required | Description |
|---|---|---|---|---|
| `domain_name` | string | no | yes | Primary domain (e.g. `example.com`) |
| `acm_certificate_arn` | string | no | yes | ARN of ACM certificate in `us-east-1` (required for CloudFront) |
| `contact_emails` | list(string) | no | yes | Destination addresses for contact form submissions |
| `contact_token` | string | yes | yes | Generate with "openssl rand -hex 64" |
| `environment_name` | string | no | no | Deployment environment name (default: `production`) |
| `aws_region` | string | no | no | AWS region for all resources (default: `us-east-1`) |
| `domain_aliases` | list(string) | no | no | Additional domain aliases (e.g. `["www.example.com"]`) |
| `hosted_zone_id` | string | no | no | Route53 hosted zone ID - optional to bypasses name lookup if set |

## License

MIT — see [LICENSE](./LICENSE).
