# Contributing to Gamified Coach Interface

Thank you for your interest in contributing to the Legion Command Center! This document provides guidelines and instructions for contributing to this project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Pull Request Process](#pull-request-process)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Documentation](#documentation)

## Code of Conduct

This project adheres to a Code of Conduct that all contributors are expected to follow. Please read [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) before contributing.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/gamified-coach-interface.git`
3. Add upstream remote: `git remote add upstream https://github.com/ivviiviivvi/gamified-coach-interface.git`
4. Create a new branch: `git checkout -b feature/your-feature-name`

## Development Setup

### Frontend Development

Requirements:
- Node.js 18+ and npm
- Modern web browser with WebGL support

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

### Backend Development

Requirements:
- Node.js 18+
- PostgreSQL
- Redis (optional)

```bash
# Navigate to backend directory
cd backend

# Install dependencies
npm install

# Set up environment variables
cp .env.example .env
# Edit .env with your database credentials

# Run migrations
npm run migrate

# Start development server
npm run dev
```

### Python Document Analysis

Requirements:
- Python 3.11+
- python-docx

```bash
# Install Python dependencies
pip install -r requirements.txt

# Run document analyzer
python3 analyze_docs.py
```

## How to Contribute

### Reporting Bugs

- Use the GitHub issue tracker
- Use the bug report template
- Include detailed steps to reproduce
- Include screenshots if applicable
- Specify your environment (OS, browser, Node version, etc.)

### Suggesting Features

- Use the GitHub issue tracker
- Use the feature request template
- Clearly describe the feature and its benefits
- Consider implementation complexity
- Be open to discussion and feedback

### Contributing Code

1. Pick an issue to work on or create a new one
2. Comment on the issue to let others know you're working on it
3. Follow the development setup instructions
4. Make your changes following our coding standards
5. Write or update tests as needed
6. Update documentation if needed
7. Submit a pull request

## Pull Request Process

1. **Before Submitting**:
   - Ensure all tests pass: `npm test`
   - Run linting: `npm run lint`
   - Update documentation if needed
   - Add tests for new features
   - Keep changes focused and atomic

2. **PR Description**:
   - Use the pull request template
   - Link related issues
   - Describe what changes were made and why
   - Include screenshots for UI changes
   - Note any breaking changes

3. **Review Process**:
   - Maintainers will review your PR
   - Address feedback and requested changes
   - Keep discussions respectful and constructive
   - Be patient - reviews take time

4. **Merging**:
   - PRs require at least one approval
   - All CI checks must pass
   - Maintainers will merge approved PRs
   - Delete your branch after merge

## Coding Standards

### JavaScript/TypeScript

- Follow existing code style
- Use ESLint configuration provided
- Use Prettier for formatting
- Write meaningful variable and function names
- Add JSDoc comments for complex functions
- Keep functions small and focused

### Python

- Follow PEP 8 guidelines
- Use type hints where applicable
- Write docstrings for functions and classes
- Keep code Python 3.11+ compatible

### HTML/CSS

- Use semantic HTML5 elements
- Follow BEM methodology for CSS classes
- Ensure accessibility (ARIA labels, keyboard navigation)
- Test responsive design on multiple screen sizes

### Git Commits

Follow Conventional Commits specification:
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, etc.)
- `refactor:` - Code refactoring
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks

Example: `feat: add holographic navigation to Strategy Core`

## Testing

- Write unit tests for new features
- Maintain or improve code coverage
- Test edge cases and error conditions
- Run full test suite before submitting PR

### Frontend Tests

```bash
npm test                # Run all tests
npm test -- --watch     # Run in watch mode
npm run test:coverage   # Generate coverage report
```

### Backend Tests

```bash
cd backend
npm test
```

## Documentation

### Code Documentation

- Add JSDoc/docstring comments for public APIs
- Explain complex algorithms or business logic
- Keep comments up to date with code changes

### User Documentation

- Update README.md for user-facing changes
- Add/update guides in docs/ directory
- Include usage examples
- Keep documentation clear and concise

### Architecture Documentation

- Document significant architectural decisions
- Update ARCHITECTURE.md for structural changes
- Explain design patterns used
- Document integration points

## Questions?

- Open an issue for questions about contributing
- Check existing issues and documentation first
- Be respectful and constructive in all communications

## License

By contributing to this project, you agree that your contributions will be licensed under the MIT License.

Thank you for contributing to the Gamified Coach Interface! 🚀
