# Sentinel's Journal

## 2024-05-22 - Missing Input Validation in Auth
**Vulnerability:** The authentication endpoints (`/register`, `/login`) lacked robust input validation and sanitization. While Sequelize provided some database-level validation (like `isEmail`), the controller did not validate input before processing, leading to potential bad data reaching the DB logic and weaker error feedback.
**Learning:** Always validate input at the edge of the application (controller/route level) before it reaches domain logic or database layers.
**Prevention:** Implemented `express-validator` middleware on auth routes to enforce email formats, password length, and sanitize inputs.

## 2024-05-24 - Socket.IO Authorization Bypass
**Vulnerability:** The `guild_message` socket event handler in `backend/server.js` blindly broadcasted messages to `guild:${guildId}` without verifying if the sender was a member of that guild. This allowed any authenticated user to send messages to any guild.
**Learning:** Socket.IO events do not pass through standard Express middleware chains. Authorization logic must be explicitly implemented within each event handler or via a global socket middleware that inspects the payload and user state.
**Prevention:** Added a check in the `guild_message` handler to verify `guildId` against `socket.user.guilds`. Also established a pattern for testing socket security integrations by mocking the database and using `socket.io-client` against the actual server instance.

## 2026-01-03 - Comprehensive Security Audit & Hardening
**Vulnerability:** A broad audit revealed multiple issues:
1. **Privilege Escalation:** `gamificationController.js` allowed `role` updates via `req.body`.
2. **Crash Risk:** `authController.js` used `[Op.or]` without `Op` being in scope.
3. **Mass Assignment:** `communityController.js` lacked strict validation for post content.
4. **Stale Sessions:** Token refresh did not check if user was suspended.
**Prevention:**
1. Explicitly removed sensitive fields from `req.body` updates.
2. Properly imported Sequelize operators.
3. Added strict length and type validation for all user inputs.
4. Added status checks during token refresh.
**Verification:** Added unit tests covering these specific scenarios to prevent regression.
