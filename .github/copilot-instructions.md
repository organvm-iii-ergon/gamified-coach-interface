---
description: AI rules derived by SpecStory from the project AI interaction history
globs: *
---

# Gemini CLI Instructions

## HEADERS

This section defines the standard headers to be used in all files.

## TECH STACK

- Python (3.x)
- Markdown
- docx (python-docx) - for reading docx files. Install using `pip install python-docx`.

## PROJECT DOCUMENTATION & CONTEXT SYSTEM

This section describes how documentation is structured and accessed.
- The repository organization blueprint is located in `docs/REPO_STRUCTURE.md`, detailing the current layout, pain points, proposed structure, and migration steps.
- The working prototype checklist can be found in `docs/WORKING_PROTOTYPE_CHECKLIST.md`, containing a step-by-step guide.

## CODING STANDARDS

Follow PEP 8 guidelines.

## DEBUGGING

- When debugging, pay close attention to syntax errors, type checking warnings, and unused variables.
- Address syntax errors first. Always address syntax errors first.
- Type checking warnings may arise due to missing packages. Ensure all necessary packages are installed.
- Unused variables should be removed or used to avoid clutter.
- When using npm as the preferred package manager, resolve lockfile conflicts by deleting the lockfiles that don't match your preferred package manager.

## WORKFLOW & RELEASE RULES

## BEST PRACTICES
- Frontend environment variables should be stored in `.env` at the root of the repository. This file should include placeholders for `VITE_GEMINI_API_KEY`, `VITE_BACKEND_URL`, and `VITE_APP_PORT`.