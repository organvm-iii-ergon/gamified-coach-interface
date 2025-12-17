# Sentinel's Journal

## 2024-05-22 - Missing Input Validation in Auth
**Vulnerability:** The authentication endpoints (`/register`, `/login`) lacked robust input validation and sanitization. While Sequelize provided some database-level validation (like `isEmail`), the controller did not validate input before processing, leading to potential bad data reaching the DB logic and weaker error feedback.
**Learning:** Always validate input at the edge of the application (controller/route level) before it reaches domain logic or database layers.
**Prevention:** Implemented `express-validator` middleware on auth routes to enforce email formats, password length, and sanitize inputs.
