# Gamified Coach Interface

A fitness coaching platform with gamification elements, designed to help coaches engage clients through battle-themed interfaces and achievement systems.

## Project Structure

```
.
├── docs/                          # Documentation
│   ├── source-documents/          # Original Word documents with business plans and specs
│   ├── design-specs/              # Technical design specifications
│   └── research/                  # Research notes and analysis
├── prototypes/                    # HTML prototypes and mockups
├── scripts/                       # Utility scripts
│   └── analyze_docs.py           # Document analysis tool
├── requirements.txt              # Python dependencies
└── README.md                     # This file
```

## Overview

This repository contains resources for developing a gamified fitness coaching interface. The system analyzes documentation, provides development recommendations, and includes interface prototypes.

### Document Analysis System

The analyzer ingests Word documents and provides:

- **Document Ingestion**: Reads and loads all Word documents in the repository
- **Document Digestion**: Analyzes content, extracts key topics, and generates summaries
- **Path Suggestion**: Recommends development paths based on document content

## Requirements

- Python 3.8+
- python-docx library

## Installation

1. Clone the repository:

```bash
git clone https://github.com/ivi374forivi/gamified-coach-interface.git
cd gamified-coach-interface
```

2. Create and activate a virtual environment:

```bash
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate
```

3. Install dependencies:

```bash
pip install -r requirements.txt
```

## Usage

### Running the Document Analyzer

Analyze project documentation to extract key topics and generate development recommendations:

```bash
python scripts/analyze_docs.py
```

The script will:

1. Scan for `.docx` files in `docs/source-documents/`
2. Ingest and parse each document
3. Analyze content to extract key topics and statistics
4. Provide categorization and suggested development paths

### Viewing Prototypes

HTML prototypes are located in the `prototypes/` directory. Open them in a web browser to preview interface designs.

## Output

The analyzer provides:

- List of ingested documents
- Document statistics (paragraph count, word count)
- Key topics extracted from each document
- Categorization (fitness, business, gamification themes)
- Recommended development path with actionable steps
- Suggested next steps for implementation

## Documentation

- **Source Documents** (`docs/source-documents/`): Business plans, conceptual documents
  - Blueprint for a Niche Fitness Coaching Enterprise
  - Gym Chimera
  - The Gamified Life
  - The Legion of Fitness
- **Design Specs** (`docs/design-specs/`): Technical specifications
- **Research** (`docs/research/`): Market research and application drafts

## Development Roadmap

The recommended phases (generated dynamically from document analysis):

1. **Foundation**: Core data models for fitness coaching and user profiles
2. **Interface**: User dashboard with gamified elements
3. **Coaching Features**: Personalized recommendations and progress tracking
4. **Gamification**: Achievement system, challenges, and leaderboards
5. **Business Integration**: Payment systems, analytics, and coach tools

## Contributing

This is a private project. If you have access and want to contribute:

1. Ensure Python 3.8+ is installed
2. Install dependencies: `pip install -r requirements.txt`
3. Make your changes
4. Test the analysis script: `python scripts/analyze_docs.py`
5. Submit a pull request

## License

Private/Proprietary - No public license currently included.
