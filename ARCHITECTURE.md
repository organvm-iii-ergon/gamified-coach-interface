# Architecture

This document provides a comprehensive overview of the Gamified Coach Interface project structure, architecture, and navigation guide for contributors and users.

## Table of Contents

- [Project Overview](#project-overview)
- [Repository Structure](#repository-structure)
- [Architecture Overview](#architecture-overview)
- [Documentation Map](#documentation-map)
- [Development Workflow](#development-workflow)
- [Technology Stack](#technology-stack)
- [Getting Started](#getting-started)

## Project Overview

The **Gamified Coach Interface - Legion Command Center** is a comprehensive gamified fitness coaching platform that combines cutting-edge 3D visualization with AI-powered strategy generation. The project features multiple interface versions and a robust backend system.

### Key Features

- **V3 Holographic Interface**: Three.js-powered 3D command center with Gemini AI integration
- **V2 Retro Interface**: Pixel RPG-style coaching dashboard
- **Backend API**: Express.js + Sequelize + PostgreSQL
- **Document Analysis**: Python-based strategic document ingestion system
- **AI Integration**: Gemini API for strategy generation and analysis

## Repository Structure

```
gamified-coach-interface/
├── .github/                    # GitHub-specific files
│   └── copilot-instructions.md # AI assistant instructions
│
├── backend/                    # Backend API (Express + Sequelize + PostgreSQL)
│   ├── models/                # Database models
│   ├── routes/                # API routes
│   ├── middleware/            # Express middleware
│   └── README.md              # Backend documentation
│
├── docs/                       # **All documentation**
│   ├── architecture/          # Architecture & technical design docs
│   │   ├── FRONTEND_INTEGRATION.md
│   │   ├── LOGIC_ARCHITECTURE.md
│   │   ├── LOGIC_AUDIT.md
│   │   └── OPTIMIZATIONS.md
│   ├── design-specs/          # UI/UX design specifications
│   │   └── legion-cc-v3-design-spec.md
│   ├── operational/           # Operational & process docs
│   │   ├── CLAUDE.md
│   │   ├── MERGE_SUMMARY.md
│   │   ├── ORGANIZATION.md
│   │   ├── PR20_REVIEW_IMPLEMENTATION.md
│   │   ├── STATUS.md
│   │   ├── TODO.md
│   │   └── tree-repository-pre-sort.md
│   ├── research/              # Research & strategy documents
│   │   ├── legionCommandCenter-applicationDrafts_Gemini.md
│   │   └── legionCommandCenter-fitnessNicheResearch_Gemini.md
│   ├── source-documents/      # Raw source documents
│   ├── NORTH_STAR.md          # Project vision and goals
│   ├── REPO_STRUCTURE.md      # Repository organization blueprint
│   ├── USAGE.md               # Usage documentation
│   └── WORKING_PROTOTYPE_CHECKLIST.md
│
├── prototypes/                 # Legacy HTML experiments (deprecated)
│   ├── client.html
│   ├── index.html
│   ├── legion-command-center-evolved.html
│   └── Rok_Gym.html
│
├── scripts/                    # Automation & utility scripts
│   ├── analyze_docs.py        # Document analysis tool
│   ├── manage_vscode_extensions.sh
│   └── README-extensions.md
│
├── src/                        # Frontend application source
│   ├── main.js                # V3 main application logic
│   ├── SceneManager.js        # Three.js scene management
│   ├── StrategyCore.js        # 3D holographic core object
│   └── OrbitalNodes.js        # Navigation node system
│
├── verification/               # Testing & verification
│
├── client.html                 # V2 client-facing interface
├── index.html                  # V2 command center interface
├── legion-v3.html              # **V3 holographic interface (main)**
├── legion-command-center-evolved.html  # Alternative V3 version
│
├── vite.config.js              # Vite build configuration
├── vitest.config.js            # Vitest testing configuration
├── package.json                # Node.js dependencies
│
├── requirements.txt            # Python dependencies
│
├── README.md                   # **Start here!**
├── ARCHITECTURE.md             # **This file**
├── CONTRIBUTING.md             # Contribution guidelines
├── CODE_OF_CONDUCT.md          # Community standards
├── SECURITY.md                 # Security policies
└── LICENSE                     # MIT License
```

## Architecture Overview

### Frontend Architecture

The frontend uses a modular architecture with multiple versions:

#### V3 - Holographic Interface (Primary)
- **Entry Point**: `legion-v3.html`
- **Technology**: Three.js, Vite, Vanilla JavaScript
- **Design**: Neo-brutalist holographic interface inspired by Blade Runner 2049
- **Components**:
  - `SceneManager.js`: Manages Three.js scene, camera, renderer
  - `StrategyCore.js`: Central 3D holographic object with state management
  - `OrbitalNodes.js`: 5 navigation nodes orbiting the core
  - `main.js`: Application initialization and module coordination

**Modules**:
1. **TARGET ANALYSIS** (Cyan) - AI-powered strategy generation
2. **INTEL VISUALIZATION** (Orange) - Market analysis
3. **FIELD OPERATIONS** (Green) - Operational dashboard
4. **TRAINING PROTOCOLS** (Blue) - Knowledge base
5. **DATA ARCHIVE** (Grey) - Document access

#### V2 - Retro Interface (Functional)
- **Entry Points**: `index.html` (command center), `client.html` (client view)
- **Design**: Pixel RPG-style (Final Fantasy inspired)
- **Technology**: Vanilla JavaScript + Gemini API

#### V1 - Document Analysis (Complete)
- **Entry Point**: `scripts/analyze_docs.py`
- **Technology**: Python 3.11+, python-docx
- **Purpose**: Strategic document ingestion and analysis

### Backend Architecture

- **Framework**: Express.js
- **Database**: PostgreSQL with Sequelize ORM
- **Caching**: Redis (optional)
- **Location**: `backend/` directory

**Key Components**:
- RESTful API endpoints
- Database models and migrations
- Authentication & authorization middleware
- CORS configuration
- Error handling

### Data Flow

```
User Interface (legion-v3.html)
    ↓
Three.js Visualization Layer
    ↓
JavaScript Application Logic (src/)
    ↓
    ├─→ Gemini AI API (strategy generation)
    └─→ Backend API (backend/)
         ↓
    PostgreSQL Database
```

## Documentation Map

### For New Contributors
1. Start with [README.md](README.md) - Project overview and quick start
2. Read [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution guidelines
3. Review [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) - Community standards
4. Check [docs/WORKING_PROTOTYPE_CHECKLIST.md](docs/WORKING_PROTOTYPE_CHECKLIST.md) - Development roadmap

### For Developers

#### Frontend Development
- [docs/design-specs/legion-cc-v3-design-spec.md](docs/design-specs/legion-cc-v3-design-spec.md) - V3 design specification
- [docs/architecture/FRONTEND_INTEGRATION.md](docs/architecture/FRONTEND_INTEGRATION.md) - Frontend integration guide
- [docs/USAGE.md](docs/USAGE.md) - Usage documentation

#### Backend Development
- [backend/README.md](backend/README.md) - Backend setup and API docs
- [docs/architecture/LOGIC_ARCHITECTURE.md](docs/architecture/LOGIC_ARCHITECTURE.md) - System architecture
- [docs/architecture/LOGIC_AUDIT.md](docs/architecture/LOGIC_AUDIT.md) - Architecture audit

#### Project Management
- [docs/NORTH_STAR.md](docs/NORTH_STAR.md) - Project vision and goals
- [docs/operational/STATUS.md](docs/operational/STATUS.md) - Current status
- [docs/operational/TODO.md](docs/operational/TODO.md) - Task list
- [docs/REPO_STRUCTURE.md](docs/REPO_STRUCTURE.md) - Repository organization

#### Research & Strategy
- [docs/research/legionCommandCenter-applicationDrafts_Gemini.md](docs/research/legionCommandCenter-applicationDrafts_Gemini.md)
- [docs/research/legionCommandCenter-fitnessNicheResearch_Gemini.md](docs/research/legionCommandCenter-fitnessNicheResearch_Gemini.md)

### For Security Researchers
- [SECURITY.md](SECURITY.md) - Security policy and vulnerability reporting

## Development Workflow

### Frontend Development

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Run tests
npm test

# Build for production
npm run build
```

**Environment Variables** (`.env`):
```
VITE_GEMINI_API_KEY=your_api_key
VITE_BACKEND_URL=http://localhost:5000
VITE_APP_PORT=3000
```

### Backend Development

```bash
# Navigate to backend
cd backend

# Install dependencies
npm install

# Setup database
npm run migrate

# Start development server
npm run dev
```

**Environment Variables** (`backend/.env`):
```
DATABASE_URL=postgresql://user:pass@localhost:5432/dbname
JWT_SECRET=your_secret
REDIS_URL=redis://localhost:6379
```

### Python Document Analysis

```bash
# Install dependencies
pip install -r requirements.txt

# Run analyzer
python3 scripts/analyze_docs.py
```

## Technology Stack

### Frontend
- **Core**: Vanilla JavaScript (ES6+)
- **3D Graphics**: Three.js
- **Build Tool**: Vite
- **Testing**: Vitest
- **CSS**: Custom (neo-brutalist design system)

### Backend
- **Runtime**: Node.js 18+
- **Framework**: Express.js
- **Database**: PostgreSQL
- **ORM**: Sequelize
- **Caching**: Redis (optional)

### AI/ML
- **Primary**: Google Gemini API
- **Purpose**: Strategy generation, document analysis, business intelligence

### DevOps
- **Version Control**: Git
- **Package Manager**: npm
- **Linting**: ESLint, Prettier, Pylint
- **CI/CD**: GitHub Actions (planned)

### Python Tools
- **Version**: Python 3.11+
- **Key Libraries**: python-docx

## Getting Started

### Prerequisites
- Node.js 18+
- PostgreSQL (for backend)
- Python 3.11+ (for document analysis)
- Modern browser with WebGL support
- Git

### Quick Start

1. **Clone the repository**:
```bash
git clone https://github.com/ivviiviivvi/gamified-coach-interface.git
cd gamified-coach-interface
```

2. **Frontend setup**:
```bash
npm install
cp .env.example .env  # Configure your API keys
npm run dev
```

3. **Backend setup** (in separate terminal):
```bash
cd backend
npm install
cp .env.example .env  # Configure database
npm run migrate
npm run dev
```

4. **Open in browser**:
```
http://localhost:3000/legion-v3.html
```

### Development Resources

- **Main Interface**: http://localhost:3000/legion-v3.html
- **Backend API**: http://localhost:5000
- **API Documentation**: http://localhost:5000/api-docs (when implemented)

## Project Status

The project is under active development:
- ✅ **V3 Holographic Interface**: Core functionality complete
- ✅ **Gemini AI Integration**: Working in frontend
- ✅ **Backend API**: Basic structure in place
- 🚧 **Database Integration**: In progress
- 🚧 **Authentication**: Planned
- 🚧 **CI/CD Pipeline**: Planned

For detailed status, see [docs/operational/STATUS.md](docs/operational/STATUS.md).

## Contributing

We welcome contributions! Please read:
1. [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution process
2. [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) - Community guidelines
3. [docs/WORKING_PROTOTYPE_CHECKLIST.md](docs/WORKING_PROTOTYPE_CHECKLIST.md) - Development priorities

## License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

## Support

- **Issues**: Report bugs via GitHub Issues
- **Security**: Report vulnerabilities per [SECURITY.md](SECURITY.md)
- **Questions**: Open a discussion or issue on GitHub

---

**Last Updated**: 2024-12-19

For the latest updates, see [docs/operational/STATUS.md](docs/operational/STATUS.md).
