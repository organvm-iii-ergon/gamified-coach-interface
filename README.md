[![ORGAN-III: Ergon](https://img.shields.io/badge/ORGAN--III-Ergon-1b5e20?style=flat-square)](https://github.com/organvm-iii-ergon)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)
[![Node.js](https://img.shields.io/badge/Node.js-18%2B-339933?style=flat-square&logo=node.js&logoColor=white)](https://nodejs.org/)
[![Three.js](https://img.shields.io/badge/Three.js-r160-000000?style=flat-square&logo=three.js)](https://threejs.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-4169E1?style=flat-square&logo=postgresql&logoColor=white)](https://www.postgresql.org/)

<div align="center">

# Gamified Coach Interface

[![CI](https://github.com/organvm-iii-ergon/gamified-coach-interface/actions/workflows/ci.yml/badge.svg)](https://github.com/organvm-iii-ergon/gamified-coach-interface/actions/workflows/ci.yml)
[![Coverage](https://img.shields.io/badge/coverage-pending-lightgrey)](https://github.com/organvm-iii-ergon/gamified-coach-interface)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/organvm-iii-ergon/gamified-coach-interface/blob/main/LICENSE)
[![Organ III](https://img.shields.io/badge/Organ-III%20Ergon-F59E0B)](https://github.com/organvm-iii-ergon)
[![Status](https://img.shields.io/badge/status-active-brightgreen)](https://github.com/organvm-iii-ergon/gamified-coach-interface)
[![TypeScript](https://img.shields.io/badge/lang-TypeScript-informational)](https://github.com/organvm-iii-ergon/gamified-coach-interface)


### Legion Command Center — A 3D Holographic Coaching Platform for Fitness Entrepreneurs

*Transform fitness coaching from transactional service delivery into an immersive strategic experience where coaches become commanders and clients become heroes in their own transformation story.*

**[Quick Start](#quick-start)** · **[Architecture](#technical-architecture)** · **[Features](#features--ux-design)** · **[API Configuration](#api-configuration)** · **[Contributing](#contributing)**

</div>

---

## Product Overview

The fitness coaching industry is worth over $40 billion, yet roughly 80% of independent coaches fail within two years. They burn 20+ hours per week on administrative overhead — client tracking, content generation, competition research, brand strategy — rather than the transformational coaching work that drew them to the profession. The tools available to them are either glorified spreadsheets or bloated SaaS platforms that treat coaching as an afterthought behind generic project management.

**Gamified Coach Interface** (internally: *Legion Command Center*) takes a fundamentally different approach. It reframes the coaching business as a strategic command center, wrapping serious operational tooling inside an immersive, gamified interface that makes the work of building a coaching empire feel like commanding a mission. The platform integrates AI-powered strategic analysis (via Google Gemini), real-time 3D visualization (via Three.js), and a full-stack backend with quest systems, achievement tracking, community features, and Stripe-powered payments.

This is not gamification-as-decoration. The game mechanics *are* the core architecture. Every user action has a game-state consequence. Every database table supports progression tracking. The result is a platform where a fitness entrepreneur can define their target customer avatar, design their monetization ladder, craft their brand narrative, research competitors, plan weekly execution, build community structure, and generate content frameworks — all from within a single, narratively coherent interface that rewards strategic discipline with measurable progress.

### The Three Versions

The project has evolved through three distinct design phases, each still functional:

| Version | Design Language | Technology | Status |
|---------|----------------|------------|--------|
| **V1** | Minimal document analysis | Python + python-docx | Complete |
| **V2** | Retro pixel RPG (Final Fantasy-inspired) | Vanilla JS + Gemini API | Functional |
| **V3** | Neo-brutalist holographic (Blade Runner 2049) | Three.js + Vite + Gemini API | Primary / Active |

**V3** is the current primary interface — a classified-government-data-analysis aesthetic where the user operates as a Commander accessing strategic intelligence through a cinematic, 3D holographic experience. The design draws direct inspiration from Kanye2049's neo-brutalist interface, translated into the fitness coaching domain: where POTUS OS becomes LEGION OS, where leaked-album artifacts become business intelligence Strategy Cores, and where solution nodes become implementation checklists.

### The Seven Strategic Terminals

At the conceptual heart of the platform sits a fixed framework of seven strategic terminals — the complete strategy loop for any fitness coaching business:

1. **Hero Class** — Define your target customer avatar (who you serve)
2. **Loot Table** — Design your monetization ladder (how you earn)
3. **Propaganda** — Craft your brand narrative (how you're perceived)
4. **Threat Analysis** — Research competitors and market landscape (what you face)
5. **Mission Logs** — Plan weekly execution cadence (what you do)
6. **Guild Charter** — Design community structure and culture (who surrounds you)
7. **Scriptorium** — Generate content frameworks and templates (what you publish)

These seven are *sacred structure* — they represent the complete strategic cycle and are not expanded or reduced. Every AI interaction, every module, every quest in the system maps back to one or more of these terminals.

---

## Technical Architecture

### System Overview

The platform is a full-stack application with three major layers: a 3D frontend, a RESTful backend API, and a PostgreSQL persistence layer, with Google Gemini providing AI capabilities and Stripe handling payments.

```
┌─────────────────────────────────────────────────────────────┐
│                      CLIENT LAYER                           │
│                                                             │
│  legion-v3.html ──► Three.js Scene                          │
│       │               ├── SceneManager.js (renderer, cam)   │
│       │               ├── StrategyCore.js (central 3D obj)  │
│       │               ├── OrbitalNodes.js (5 nav nodes)     │
│       │               └── main.js (init + module coord)     │
│       │                                                     │
│       ├── index.html ──► V2 Command Center (retro pixel)    │
│       └── client.html ─► V2 Client-Facing Interface         │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│                      API LAYER                              │
│                                                             │
│  Express.js (backend/server.js)                             │
│       ├── Authentication (JWT + bcrypt + refresh tokens)    │
│       ├── 13 Route Modules:                                 │
│       │   auth, users, quests, achievements, skills,        │
│       │   community, strategy, fitness, content,            │
│       │   payments, analytics, leaderboards, notifications  │
│       ├── Socket.IO (real-time events: guilds, alerts)      │
│       ├── Helmet + CORS + rate limiting                     │
│       └── Winston logging + Morgan HTTP logs                │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│                    PERSISTENCE LAYER                        │
│                                                             │
│  PostgreSQL (Sequelize ORM)                                 │
│       ├── 20+ tables (users, quests, achievements, ...)    │
│       ├── UUID primary keys throughout                      │
│       ├── ENUM types for roles, tiers, statuses             │
│       └── Full-text search on content tables                │
│                                                             │
│  Redis (optional cache layer for sessions + leaderboards)   │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│                   EXTERNAL SERVICES                         │
│                                                             │
│  Google Gemini API ─── AI strategy generation               │
│  Stripe API ────────── Payment processing                   │
│  Socket.IO ─────────── Real-time guild + notification sync  │
└─────────────────────────────────────────────────────────────┘
```

### Frontend: Three.js Holographic Interface (V3)

The V3 frontend is built with **Vite** as the build tool and **Three.js** as the 3D rendering engine. The scene architecture follows a hub-and-spoke model:

- **`SceneManager.js`** — Initializes the Three.js scene, camera, and WebGL renderer. Manages the render loop targeting 60fps on desktop with graceful degradation on less capable hardware.
- **`StrategyCore.js`** — The central 3D holographic object that the user sees on load. It morphs and glitches in response to API calls (Gemini responses trigger visual distortion effects), reinforcing the narrative that the user is accessing live strategic intelligence.
- **`OrbitalNodes.js`** — Five navigation nodes orbiting the Strategy Core, each mapped to a functional module: Target Analysis (cyan), Intel Visualization (orange), Field Operations (green), Training Protocols (blue), and Data Archive (grey).
- **`main.js`** — Application initialization, module coordination, and event routing between 3D scene events and UI overlays.

The interface follows a scene-based navigation pattern. First-time visitors experience a linear boot sequence (LEGION OS boot screen, holographic login, data hub reveal), while returning users land directly on the hub and can navigate freely between orbital nodes.

### Backend: Express.js API

The backend is a conventional Express.js application with 13 route modules covering the full surface area of a coaching SaaS platform:

- **Authentication** (`/api/auth`) — Registration, login, JWT issuance, refresh token rotation, password reset. Passwords hashed with bcrypt; tokens stored in PostgreSQL with expiry tracking.
- **User Management** (`/api/users`) — Profile CRUD, avatar upload (via multer + sharp for image processing), timezone preferences, subscription tier management.
- **Quest System** (`/api/quests`) — The core gamification engine. Quests are parameterized tasks (daily, weekly, epic, story-arc) with XP rewards, completion conditions, and chain dependencies.
- **Achievements** (`/api/achievements`) — Milestone-based unlocks triggered by cumulative quest completion, streak maintenance, or special conditions.
- **Skills** (`/api/skills`) — Skill tree progression where XP earned in specific categories (marketing, content, client management, etc.) unlocks deeper capabilities.
- **Community** (`/api/community`) — Guild creation, membership, chat (via Socket.IO), and shared leaderboards. Guilds provide accountability structure for coaches.
- **Strategy** (`/api/strategy`) — The Gemini AI integration endpoint. Accepts strategy parameters (target avatar, business model, competitive landscape), forwards to Gemini with the 7-Terminal framework as system context, and returns structured strategic intelligence.
- **Fitness** (`/api/fitness`) — Workout logging, program templates, and client progress tracking — the domain-specific layer that distinguishes this from a generic business tool.
- **Content** (`/api/content`) — Content calendar, template library, and AI-assisted content generation mapped to the Scriptorium terminal.
- **Payments** (`/api/payments`) — Stripe integration for subscription management across five tiers: Free, Potion, Core Quest, Raid, and Mastermind.
- **Analytics** (`/api/analytics`) — Usage metrics, engagement tracking, and exportable reports (PDF generation via pdfkit).
- **Leaderboards** (`/api/leaderboards`) — XP-based rankings with Redis caching for performance at scale.
- **Notifications** (`/api/notifications`) — Real-time push via Socket.IO and persistent notification storage for offline users.

### Database Schema

The PostgreSQL schema uses UUIDs throughout and is organized around the gamification-as-infrastructure principle. Key design decisions:

- **Subscription tiers as ENUM** (`free`, `potion`, `core_quest`, `raid`, `mastermind`) — the tier names reflect the game metaphor and map to Stripe price IDs.
- **XP is tracked at multiple levels** — per-user aggregate XP, per-skill category XP, per-quest XP awards — enabling both global leaderboards and skill-specific progression.
- **Quests support chain dependencies** — a quest can require completion of predecessor quests, enabling story-arc narratives (e.g., "Complete Hero Class terminal" requires completing 5 sub-quests defining your avatar).
- **Guilds with role-based access** — guild members, officers, and leaders have different permission levels, supporting real coaching cohort structures.
- **Full audit trail** — `created_at` and `updated_at` timestamps on every table, with soft-delete support via status ENUMs rather than destructive deletion.

### Document Analysis System (V1)

A Python-based strategic document ingestion pipeline (`scripts/analyze_docs.py`) that scans `.docx` files, extracts key topics and statistics, categorizes content by theme (fitness, business, gamification), and generates a recommended development path. This was the project's first iteration and remains functional as a standalone tool.

---

## Quick Start

### Prerequisites

- **Node.js** 18+ and npm 9+
- **PostgreSQL** 15+ (for backend features)
- **Python** 3.11+ (optional, for document analysis)
- A modern browser with WebGL support
- (Optional) Google Gemini API key for AI-powered strategy generation
- (Optional) Redis for leaderboard caching

### Frontend Only (V3 Holographic Interface)

```bash
# Clone the repository
git clone https://github.com/organvm-iii-ergon/gamified-coach-interface.git
cd gamified-coach-interface

# Install frontend dependencies
npm install

# Start the Vite development server
npm run dev

# Open http://localhost:3000/legion-v3.html
```

The V3 holographic interface will load with the LEGION OS boot sequence. AI strategy generation requires a Gemini API key (see [API Configuration](#api-configuration) below); all other features work without external services.

### Full Stack (Frontend + Backend)

```bash
# Clone and install all dependencies
git clone https://github.com/organvm-iii-ergon/gamified-coach-interface.git
cd gamified-coach-interface
npm run install:all

# Configure the backend environment
cp backend/.env.example backend/.env
# Edit backend/.env with your PostgreSQL credentials, JWT secret, Stripe keys, etc.

# Run database migrations and seed data
cd backend
npm run migrate
npm run seed
cd ..

# Start both frontend and backend
# Terminal 1: Frontend
npm run dev

# Terminal 2: Backend
cd backend
npm run dev
```

### Document Analysis (V1 Python Tool)

```bash
# Install Python dependencies
pip install -r requirements.txt

# Run the document analyzer
python3 scripts/analyze_docs.py
```

The analyzer scans the repository for `.docx` source documents, extracts themes and statistics, and outputs a categorized development roadmap.

### Production Build

```bash
# Build optimized frontend assets
npm run build

# Preview the production build
npm run preview

# Start backend in production mode
cd backend
NODE_ENV=production npm start
```

### Running Tests

```bash
# All tests (frontend + backend)
npm run test:all

# Frontend tests only (Vitest)
npm run test:frontend

# Backend tests only (Jest with coverage)
npm run test:backend
```

---

## Features & UX Design

### V3 Holographic Interface Modules

The V3 interface organizes functionality into five orbital modules, each accessible by clicking its corresponding navigation node or using the bottom menu bar:

#### 1. Target Analysis (Cyan Node) — Strategy Forge

The primary strategy generation module. Users fill out structured parameters — target customer avatar, transformation goals, competitive landscape — and the system forwards these to Google Gemini with the 7-Terminal framework as system context. The AI returns structured strategic intelligence: actionable checklists, competitive positioning frameworks, and decision matrices. A fallback analysis engine operates without an API key for offline use.

When the AI responds, the central Strategy Core object *visually distorts and glitches*, reinforcing the narrative that live intelligence is being processed. Results are saveable to persistent workspaces — a core data-sovereignty principle: every strategic decision, AI conversation, and generated plan belongs to the user.

#### 2. Intel Visualization (Orange Node) — Market Landscape

Market analysis and competitive intelligence visualization. Displays the coaching landscape as visual data maps, helping coaches identify positioning opportunities and competitive gaps. Currently renders static market data with plans for live data integration.

#### 3. Field Operations (Green Node) — Operational Dashboard

The day-to-day command center for active client management, quest tracking, and operational metrics. Surfaces the most urgent tasks and streaks, integrating with the backend quest and analytics APIs to provide a real-time operational picture.

#### 4. Training Protocols (Blue Node) — Knowledge Base

An educational module containing business strategy frameworks, coaching methodology references, and the theoretical foundations that inform the platform's design. Content is structured as "training missions" — consumable modules that award XP on completion.

#### 5. Data Archive (Grey Node) — Strategic Document Repository

Access point for all analyzed strategic documents, AI-generated strategy reports, and reference materials. Integrates with the V1 document analysis system to surface insights from the original source documents that informed the platform's development.

### Gamification Engine

The gamification layer is not a cosmetic overlay — it is the structural backbone of the user experience:

- **XP and Leveling** — Every meaningful action (completing a strategy session, logging a workout, publishing content, maintaining a streak) awards experience points. XP accumulates toward level thresholds, with each level unlocking new titles (Recruit, Centurion, Commander, Imperator, etc.) and platform capabilities.
- **Quest System** — Tasks are modeled as quests with defined objectives, XP rewards, and chain dependencies. Daily quests maintain engagement cadence; weekly quests drive strategic milestones; epic quests represent major business achievements (first paying client, first 50 subscribers, etc.).
- **Achievement Badges** — Milestone-based unlocks that serve as portfolio evidence of coaching business development. Achievements are visible on profiles and shareable.
- **Streaks and Consistency** — Login streaks and activity streaks with escalating XP multipliers. The system tracks both current and longest streak, creating a persistent motivation mechanic.
- **Skill Trees** — XP earned in specific categories (marketing, content creation, client management, community building) feeds into per-skill progression, making the coach's growing expertise visible and trackable.
- **Leaderboards** — Guild-scoped and global leaderboards with Redis-cached rankings, fostering healthy competition between coaching cohorts.
- **Subscription Tiers** — Five tiers (Free, Potion, Core Quest, Raid, Mastermind) gate advanced features behind Stripe-managed subscriptions, with each tier name reinforcing the game metaphor.

### Three Core Design Principles

Every feature decision is filtered through these immutable principles (documented fully in [`docs/NORTH_STAR.md`](docs/NORTH_STAR.md)):

1. **Gamification as Infrastructure, Not Decoration** — If a feature cannot be gamified, question whether it belongs. Game mechanics are not applied after the fact; they *are* the architecture. A workout log is a quest completion. A calendar is a battle timeline. A content plan is a scriptorium mission.

2. **AI as Strategic Advisor, Not Content Generator** — Gemini integration must help coaches *decide*, not just *read*. Every AI response is contextualized within the 7-Terminal framework, building a persistent knowledge graph rather than generating throwaway text. If an AI feature only produces content for consumption, it is rejected or redesigned.

3. **Data Sovereignty: The User Owns Their Strategy** — All AI conversations, generated plans, and strategic decisions are exportable (JSON, Markdown, PDF). No vendor lock-in. No training on user data. Data structures are open and documented.

---

## API Configuration

### Gemini AI Integration

To enable AI-powered strategy generation in the V3 interface:

1. Obtain a Gemini API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Navigate to the **Target Analysis** module (cyan node)
3. Fill out the strategy parameters form
4. Click **INITIATE STRATEGIC ANALYSIS**
5. Enter your API key when prompted (saved to local storage for future sessions)

The key is stored client-side only and never transmitted to the backend. For backend AI features, configure `GEMINI_API_KEY` in `backend/.env`.

### Stripe Payments

Configure Stripe for subscription management:

```env
STRIPE_SECRET_KEY=sk_live_...
STRIPE_WEBHOOK_SECRET=whsec_...
STRIPE_PRICE_FREE=price_...
STRIPE_PRICE_POTION=price_...
STRIPE_PRICE_CORE_QUEST=price_...
STRIPE_PRICE_RAID=price_...
STRIPE_PRICE_MASTERMIND=price_...
```

### Environment Variables

Copy `backend/.env.example` to `backend/.env` and configure:

| Variable | Description | Required |
|----------|-------------|----------|
| `DATABASE_URL` | PostgreSQL connection string | Yes |
| `JWT_SECRET` | Secret for signing JWT tokens | Yes |
| `JWT_REFRESH_SECRET` | Secret for refresh tokens | Yes |
| `CORS_ORIGIN` | Allowed frontend origins (comma-separated) | Yes |
| `GEMINI_API_KEY` | Google Gemini API key | Optional |
| `STRIPE_SECRET_KEY` | Stripe secret key | Optional |
| `REDIS_URL` | Redis connection string for caching | Optional |
| `PORT` | Backend server port (default: 5000) | No |

Frontend environment variables (Gemini key, backend URL) are configured in a root `.env` file — copy and fill before running `npm run dev`.

---

## Project Structure

```
gamified-coach-interface/
├── legion-v3.html              # V3 holographic interface (primary entry point)
├── index.html                  # V2 retro command center
├── client.html                 # V2 client-facing interface
│
├── src/                        # V3 frontend source
│   ├── main.js                 # Application init + module coordination
│   ├── SceneManager.js         # Three.js scene, camera, renderer
│   ├── StrategyCore.js         # Central 3D holographic object
│   ├── OrbitalNodes.js         # 5 orbital navigation nodes
│   └── tests/                  # Frontend smoke tests (Vitest)
│
├── backend/                    # Express.js API
│   ├── server.js               # Server entry point
│   ├── config/                 # Database configuration
│   ├── controllers/            # Request handlers
│   ├── middleware/              # Auth, error handling, rate limiting
│   ├── migrations/             # Sequelize migrations
│   ├── models/                 # Sequelize ORM models
│   ├── routes/                 # 13 API route modules
│   ├── services/               # Business logic (analytics, etc.)
│   ├── utils/                  # Logger, validators, formatters
│   ├── database/               # SQL schema + seed data
│   └── tests/                  # Jest test suite
│
├── scripts/                    # Automation + document analysis
│   ├── analyze_docs.py         # V1 document ingestion tool
│   └── manage_vscode_extensions.sh
│
├── prototypes/                 # Legacy HTML experiments
│   ├── Rok_Gym.html            # Early fitness tracking prototype
│   ├── client.html             # Early client interface
│   └── legion-command-center-evolved.html
│
├── docs/                       # Comprehensive documentation
│   ├── NORTH_STAR.md           # Guiding principles + 7-Terminal framework
│   ├── INDEX.md                # Documentation map
│   ├── architecture/           # Technical architecture docs
│   ├── design-specs/           # V3 design specification
│   ├── operational/            # Status, TODO, merge history
│   ├── research/               # Market research + Gemini drafts
│   └── source-documents/       # Original .docx strategy documents
│
├── verification/               # Testing + accessibility verification
├── vite.config.js              # Vite build configuration
├── vitest.config.js            # Vitest test configuration
├── package.json                # Frontend dependencies (Three.js, Vite)
├── requirements.txt            # Python dependencies (python-docx)
│
├── ARCHITECTURE.md             # Architecture guide
├── CONTRIBUTING.md             # Contribution guidelines
├── CODE_OF_CONDUCT.md          # Community standards
├── SECURITY.md                 # Security policy
└── LICENSE                     # MIT License
```

---

## Cross-Organ Context

This repository sits within **ORGAN-III (Ergon)** — the Commerce organ of the eight-organ [organvm](https://github.com/meta-organvm) creative-institutional system. ORGAN-III houses all product-facing repositories: SaaS platforms, B2B tools, B2C applications, and internal tooling.

Gamified Coach Interface draws on theoretical foundations developed in **ORGAN-I (Theoria)**, where recursive systems theory, ontological design patterns, and epistemological frameworks are explored as first-class research subjects. The gamification-as-infrastructure principle — the idea that game mechanics should be structural rather than decorative — originates in ORGAN-I's work on systems that produce emergent behavior through layered rule sets. The 7-Terminal framework similarly reflects ORGAN-I thinking about complete conceptual loops and fixed-point structures.

The platform's public-facing narrative and build-in-public documentation live in **ORGAN-V (Logos)**, where the process of constructing this system is itself a subject of reflective writing. The community features (guilds, shared leaderboards, coaching cohorts) connect conceptually to **ORGAN-VI (Koinonia)**, the Community organ that explores how groups form, sustain, and govern themselves.

| Organ | Relationship | Example |
|-------|-------------|---------|
| [ORGAN-I: Theoria](https://github.com/organvm-i-theoria) | Theoretical foundations | Recursion patterns, gamification-as-infrastructure principle |
| [ORGAN-II: Poiesis](https://github.com/organvm-ii-poiesis) | Aesthetic language | Neo-brutalist design system, holographic UI vocabulary |
| [ORGAN-V: Logos](https://github.com/organvm-v-logos) | Public process | Build-in-public essays on platform development |
| [ORGAN-VI: Koinonia](https://github.com/organvm-vi-koinonia) | Community patterns | Guild mechanics, cohort accountability structures |

---

## Related Work

Within the ORGAN-III ecosystem, Gamified Coach Interface sits alongside several related commercial repositories:

- **[public-record-data-scrapper](https://github.com/organvm-iii-ergon/public-record-data-scrapper)** — Data scraping infrastructure for public records, demonstrating a different flavor of ORGAN-III's commercial orientation (B2B data tooling vs. B2C SaaS).
- **[tab-bookmark-manager](https://github.com/organvm-iii-ergon/tab-bookmark-manager)** — Browser extension for bookmark management, representing ORGAN-III's internal-tooling category.
- **[virgil-training-overlay](https://github.com/organvm-iii-ergon/virgil-training-overlay)** — AI training overlay system with thematic connections to the coaching and education domain.

---

## Keyboard Shortcuts

| Key | Action |
|-----|--------|
| `ESC` | Close active terminal or modal |
| Click | Navigate between orbital nodes and menu items |

---

## Contributing

Contributions are welcome. Please review these resources before submitting a pull request:

- **[CONTRIBUTING.md](CONTRIBUTING.md)** — Development setup, code style, PR process, and testing requirements
- **[CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)** — Community standards and expected behavior
- **[ARCHITECTURE.md](ARCHITECTURE.md)** — Full architecture guide and documentation map
- **[SECURITY.md](SECURITY.md)** — Vulnerability reporting policy

### Quick Contribution Steps

```bash
# Fork and clone
git clone https://github.com/<your-username>/gamified-coach-interface.git

# Create a feature branch
git checkout -b feature/your-feature-name

# Install all dependencies
npm run install:all

# Make changes, then run tests
npm run test:all

# Commit and push
git add .
git commit -m "Add your feature description"
git push origin feature/your-feature-name

# Open a pull request against main
```

---

## License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for full terms.

---

## Author

**[@4444j99](https://github.com/4444j99)**

Part of the [organvm](https://github.com/meta-organvm) eight-organ creative-institutional system.
ORGAN-III: Ergon — Commerce, products, and applied systems.
