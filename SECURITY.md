# Security Policy

## Supported Versions

We release patches for security vulnerabilities for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| main    | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

The Gamified Coach Interface team takes security vulnerabilities seriously. We appreciate your efforts to responsibly disclose your findings.

### How to Report

**Please do not report security vulnerabilities through public GitHub issues.**

Instead, please report security vulnerabilities by:

1. **Opening a GitHub Security Advisory**:
   - Go to the [Security tab](https://github.com/ivviiviivvi/gamified-coach-interface/security/advisories)
   - Click "Report a vulnerability"
   - Fill out the advisory form with details

2. **Email** (if GitHub Security Advisory is not available):
   - Send an email with details to the repository maintainers
   - Include a descriptive subject line
   - Provide detailed information about the vulnerability

### What to Include

Please include the following information in your report:

- Type of vulnerability (e.g., SQL injection, XSS, authentication bypass)
- Full paths of source file(s) related to the vulnerability
- Location of the affected source code (tag/branch/commit or direct URL)
- Step-by-step instructions to reproduce the issue
- Proof-of-concept or exploit code (if possible)
- Impact of the vulnerability, including how an attacker might exploit it

### Response Timeline

- **Initial Response**: Within 48 hours, we will acknowledge receipt of your report
- **Status Update**: Within 7 days, we will provide a detailed response with next steps
- **Resolution**: We will work to fix confirmed vulnerabilities as quickly as possible
- **Disclosure**: We will coordinate with you on the disclosure timeline

## Security Best Practices

### For Contributors

- Never commit credentials, API keys, or sensitive data
- Use environment variables for configuration
- Keep dependencies up to date
- Follow secure coding practices
- Run security linters and scanners

### For Users

#### API Keys

- Never share your Gemini API key publicly
- Store API keys in environment variables or secure configuration
- Rotate API keys if they may have been exposed
- Use the minimum required API permissions

#### Database Security

- Use strong, unique passwords for database connections
- Enable SSL/TLS for database connections in production
- Restrict database access to trusted networks
- Regularly backup your data

#### Application Security

- Keep your Node.js and npm packages updated
- Use HTTPS in production environments
- Implement proper authentication and authorization
- Sanitize user inputs
- Enable security headers

## Known Security Considerations

### Frontend Security

- **API Key Storage**: The frontend currently stores the Gemini API key in localStorage
  - This is intended for development/demo purposes only
  - For production, implement proper backend API key management
  - Consider using a backend proxy for API calls

### Backend Security

- **Database Credentials**: Ensure `.env` file is never committed
- **CORS**: Configure CORS appropriately for your deployment
- **Rate Limiting**: Implement rate limiting for API endpoints
- **Input Validation**: Validate and sanitize all user inputs

## Security Updates

Security updates will be released as soon as possible after a vulnerability is confirmed. We will:

1. Fix the vulnerability in a private branch
2. Create a security advisory on GitHub
3. Release a patch version
4. Publish the security advisory with details

## Disclosure Policy

- We request that you give us reasonable time to fix the issue before public disclosure
- We will credit security researchers who report valid vulnerabilities (unless they prefer to remain anonymous)
- We will coordinate disclosure timing with you

## Security-Related Configuration

### Environment Variables

Sensitive configuration should be stored in environment variables:

```bash
# Frontend (.env)
VITE_GEMINI_API_KEY=your_key_here
VITE_BACKEND_URL=http://localhost:5000

# Backend (backend/.env)
DATABASE_URL=postgresql://user:pass@localhost:5432/dbname
JWT_SECRET=your_secret_here
REDIS_URL=redis://localhost:6379
```

### Security Headers

The application should implement security headers in production:

- Content-Security-Policy
- X-Content-Type-Options
- X-Frame-Options
- Strict-Transport-Security
- X-XSS-Protection

## Third-Party Dependencies

We regularly monitor and update dependencies for security vulnerabilities:

- Dependabot is enabled for automated security updates
- Regular audits using `npm audit`
- Review of security advisories

## Contact

For any security-related questions or concerns, please open a security advisory or contact the maintainers through GitHub.

## Acknowledgments

We thank all security researchers who help keep the Gamified Coach Interface secure.

---

**Remember**: Security is everyone's responsibility. If you notice something suspicious, please report it.
