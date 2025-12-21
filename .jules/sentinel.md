# Sentinel's Journal

## 2024-05-22 - Missing Input Validation in Auth
**Vulnerability:** The authentication endpoints (`/register`, `/login`) lacked robust input validation and sanitization. While Sequelize provided some database-level validation (like `isEmail`), the controller did not validate input before processing, leading to potential bad data reaching the DB logic and weaker error feedback.
**Learning:** Always validate input at the edge of the application (controller/route level) before it reaches domain logic or database layers.
**Prevention:** Implemented `express-validator` middleware on auth routes to enforce email formats, password length, and sanitize inputs.

## 2024-05-23 - Broken Access Control in Socket.IO
**Vulnerability:** The `guild_message` Socket.IO event handler blindly trusted the `guildId` provided in the message payload. It did not verify that the authenticated user was actually a member of that guild before broadcasting the message to the guild room. This would allow any authenticated user to send messages to any guild, even private ones they hadn't joined.
**Learning:** Socket.IO events bypass standard Express middleware chain (like `authorize` or route guards). Each event handler must explicitly perform authorization checks, just like a controller endpoint would.
**Prevention:** Added an explicit check `!socket.user?.guilds?.includes(guildId)` inside the event handler. Future Socket.IO handlers must verify permissions against the `socket.user` object populated during the handshake.
