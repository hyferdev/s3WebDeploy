# Hyfer — Website

Static site deployed serverlessly on AWS via Terraform and GitHub Actions.

## Stack

- **Frontend**: Static HTML/CSS/JS — no framework
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
├── src/
│   ├── landing.html        # Main page
│   ├── landing.js          # Navigation + contact form logic
│   ├── styles.css          # Custom CSS (on top of Tailwind)
│   ├── tailwind.css        # Tailwind entry point (compiled to dist/)
│   ├── vendor-entry.js     # Bundled vendor entry
│   ├── fonts/
│   │   ├── inter/          # Self-hosted Inter variable font
│   │   └── fa/             # Self-hosted Font Awesome 6
│   ├── images/             # Site images and logos
│   └── dist/               # Built assets (gitignored, generated in CI)
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── modules/
│       ├── storage/        # S3 bucket (private, OAC-only)
│       ├── cdn/            # CloudFront + Route53
│       └── notifications/  # Lambda Function URL + SES contact form
├── build/
│   ├── package.json        # Build dependencies (Tailwind, esbuild)
│   └── tailwind.config.js
├── .github/workflows/
│   └── deploy.yml          # CI/CD: Terraform → build → S3 sync
└── .gitignore
```

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

## License

MIT — see [LICENSE](./LICENSE).