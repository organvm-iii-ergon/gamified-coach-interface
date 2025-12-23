# Video Production System Documentation

## Table of Contents
1. [Overview](#overview)
2. [Quick Start](#quick-start)
3. [System Architecture](#system-architecture)
4. [Installation](#installation)
5. [Usage](#usage)
6. [Configuration](#configuration)
7. [Output Format](#output-format)
8. [Troubleshooting](#troubleshooting)
9. [API Reference](#api-reference)

## Overview

The Gamified Coach Interface repository includes a fully automated video production system that generates finished MP4 videos from markdown scripts. This system is designed for creating professional walkthrough and portfolio videos suitable for non-technical hiring decision-makers.

### Key Features

- ✅ **Automated Script Processing**: Parses markdown files and extracts scenes
- ✅ **Local Text-to-Speech**: Generates narration audio using espeak or pyttsx3
- ✅ **Visual Generation**: Creates professional title cards and video clips
- ✅ **Timeline Synchronization**: Aligns audio and visuals automatically
- ✅ **FFmpeg Rendering**: Produces high-quality MP4 videos
- ✅ **Comprehensive Logging**: Detailed render logs for each video
- ✅ **Graceful Fallbacks**: Handles failures with alternative methods
- ✅ **Zero Placeholder Assets**: No watermarks or draft indicators

## Quick Start

### Prerequisites

Install required dependencies:
```bash
# Ubuntu/Debian
sudo apt-get install ffmpeg espeak

# macOS
brew install ffmpeg espeak

# Verify installation
ffmpeg -version
espeak --version
```

### Basic Usage

1. **Create a video script** (markdown format):
   ```markdown
   ## Introduction
   Welcome to our product demonstration.
   
   ## Key Features
   Here are the main capabilities...
   ```

2. **Run the video production agent**:
   ```bash
   ./scripts/produce_videos.sh
   ```

3. **Find your video**:
   ```bash
   ls video_output/*.mp4
   ```

## System Architecture

### Component Overview

```
┌─────────────────────────────────────────────────┐
│         Video Production Agent                  │
├─────────────────────────────────────────────────┤
│                                                  │
│  ┌──────────────┐      ┌──────────────┐        │
│  │ ScriptParser │─────→│ AudioGen     │        │
│  └──────────────┘      └──────────────┘        │
│         │                      │                │
│         ↓                      ↓                │
│  ┌──────────────┐      ┌──────────────┐        │
│  │ VisualGen    │─────→│ VideoRenderer│        │
│  └──────────────┘      └──────────────┘        │
│                               │                 │
│                               ↓                 │
│                        ┌──────────────┐         │
│                        │  Final MP4   │         │
│                        └──────────────┘         │
└─────────────────────────────────────────────────┘
```

### Processing Pipeline

1. **Script Scanning**: Find all scripts matching pattern
2. **Scene Parsing**: Extract structured scenes from markdown
3. **Audio Generation**: Convert text to speech (espeak/pyttsx3)
4. **Visual Creation**: Generate title cards or capture demo
5. **Timeline Sync**: Align audio and visuals
6. **Final Render**: Create MP4 with FFmpeg

### Detailed Components

#### 1. ScriptParser
- Detects markdown headings (## or ###) as scene markers
- Extracts timecodes in format `[MM:SS-MM:SS]`
- Falls back to paragraph-based scene detection
- Estimates duration: 150 words per minute

#### 2. AudioGenerator
- **Primary**: espeak (command-line TTS)
- **Fallback**: pyttsx3 (Python TTS library)
- **Last Resort**: Silent audio with correct duration
- No content paraphrasing - uses script verbatim
- Output: WAV format, 44.1kHz stereo

#### 3. VisualGenerator
Priority order for visual generation:
1. Live demo capture from `$DEMO_URL` (if provided)
2. Local app run (if no demo URL)
3. Repository visualization/diagrams
4. **Static title cards** (current implementation)

Features:
- Professional typography
- Configurable resolution
- Scene-aligned timing
- Clean, readable design

#### 4. VideoRenderer
- Concatenates video clips using FFmpeg
- Synchronizes audio and video streams
- Ensures stable frame rate and audio levels
- Produces H.264 encoded MP4
- Clean cuts, no gaps or overlaps

## Installation

### System Requirements

- **Operating System**: Linux, macOS, or Windows WSL2
- **Python**: 3.7 or higher
- **FFmpeg**: 4.0 or higher
- **Disk Space**: 500MB minimum for outputs

### Dependency Installation

#### Ubuntu/Debian
```bash
sudo apt-get update
sudo apt-get install -y ffmpeg espeak python3
```

#### macOS
```bash
brew install ffmpeg espeak python3
```

#### Python Libraries (Optional)
```bash
# Alternative TTS engine
pip install pyttsx3

# For future demo capture features
pip install playwright
playwright install
```

### Repository Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/ivviiviivvi/gamified-coach-interface.git
   cd gamified-coach-interface
   ```

2. **Make scripts executable**:
   ```bash
   chmod +x scripts/produce_videos.sh
   ```

3. **Create configuration** (optional):
   ```bash
   cp .video-production.env.example .video-production.env
   nano .video-production.env
   ```

## Usage

### Basic Usage

Process all video scripts in the repository:
```bash
./scripts/produce_videos.sh
```

### Custom Configuration

Create a custom configuration file:
```bash
cp .video-production.env.example my-config.env
```

Edit the configuration:
```env
SCRIPT_PATTERN="HIRING*.md"
VIDEO_RESOLUTION="3840x2160"
FPS="60"
```

Load and run:
```bash
source my-config.env
./scripts/produce_videos.sh
```

### Direct Python Execution

For more control, use Python directly:
```bash
export REPO_ROOT="/path/to/repo"
export SCRIPT_DIR="/path/to/scripts"
export SCRIPT_PATTERN="*.md"
export VIDEO_OUT_DIR="/path/to/output"
export VIDEO_RESOLUTION="1920x1080"
export FPS="30"

python3 scripts/video_production/generate_videos.py
```

### Processing Specific Scripts

Target specific script files:
```bash
export SCRIPT_PATTERN="HIRING_PORTFOLIO_VIDEO.md"
./scripts/produce_videos.sh
```

Or use wildcards:
```bash
export SCRIPT_PATTERN="*PORTFOLIO*.md"
./scripts/produce_videos.sh
```

## Configuration

### Environment Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `REPO_ROOT` | Absolute path to repository | Current directory | No |
| `SCRIPT_DIR` | Directory containing scripts | `$REPO_ROOT` | No |
| `SCRIPT_PATTERN` | Glob pattern for scripts | `*.md` | No |
| `VIDEO_OUT_DIR` | Output directory | `$REPO_ROOT/video_output` | No |
| `VIDEO_RESOLUTION` | Video resolution | `1920x1080` | No |
| `FPS` | Frames per second | `30` | No |
| `VOICE_MODE` | TTS mode | `local_tts` | No |
| `DEMO_URL` | Optional demo URL | Empty | No |
| `HEADLESS` | Headless browser mode | `true` | No |

### Resolution Presets

```bash
# HD (720p)
VIDEO_RESOLUTION="1280x720"

# Full HD (1080p) - Default
VIDEO_RESOLUTION="1920x1080"

# 4K UHD (2160p)
VIDEO_RESOLUTION="3840x2160"

# Custom
VIDEO_RESOLUTION="2560x1440"
```

### Frame Rate Options

```bash
# Standard
FPS="30"

# Smooth (recommended for animations)
FPS="60"

# Cinematic
FPS="24"
```

## Output Format

### Directory Structure

After processing, the output directory contains:

```
video_output/
├── audio/
│   ├── SCRIPT_NAME_narration.wav
│   └── ...
├── visuals/
│   ├── SCRIPT_NAME_scene_000.mp4
│   ├── SCRIPT_NAME_scene_001.mp4
│   └── ...
├── SCRIPT_NAME.mp4                    # Final video
├── SCRIPT_NAME_render_log.txt         # Render log
└── production_summary.txt             # Summary report
```

### Final Video Specifications

- **Format**: MP4 (H.264 video, AAC audio)
- **Resolution**: Configurable (default 1920x1080)
- **Frame Rate**: Configurable (default 30fps)
- **Audio**: 192kbps AAC stereo
- **Video Codec**: libx264, CRF 23 (high quality)
- **Compatibility**: All modern devices and platforms

### Render Log Format

Each video includes a detailed render log:

```
============================================================
RENDER LOG: SCRIPT_NAME.md
============================================================

INPUT:
  Script: /path/to/script.md
  Scenes: 8

OUTPUT:
  Audio: /path/to/audio.wav
  Video clips: 8
  Final video: /path/to/final.mp4

FALLBACKS USED:
  - Visuals: Demo capture failed, using static cards

RENDER STEPS:
  - Generated audio with espeak: ...
  - Generated 8 static title cards
  - Final video: /path/to/output.mp4
  - SUCCESS: Video rendered successfully
============================================================
```

## Troubleshooting

### Common Issues

#### 1. "No scripts found"

**Cause**: Pattern doesn't match any files  
**Solution**:
```bash
# Check your script directory
ls -la $SCRIPT_DIR/*.md

# Use absolute paths
export SCRIPT_DIR="/absolute/path/to/scripts"
export SCRIPT_PATTERN="*.md"
```

#### 2. "FFmpeg not found"

**Cause**: FFmpeg not installed or not in PATH  
**Solution**:
```bash
# Install FFmpeg
sudo apt-get install ffmpeg  # Ubuntu/Debian
brew install ffmpeg          # macOS

# Verify installation
which ffmpeg
ffmpeg -version
```

#### 3. "Audio generation failed"

**Cause**: TTS engines unavailable  
**Solution**:
```bash
# Install espeak
sudo apt-get install espeak

# Or install pyttsx3
pip install pyttsx3

# System will use silent audio as last resort
```

#### 4. "Video rendering failed"

**Cause**: FFmpeg errors or missing fonts  
**Solutions**:
```bash
# Check FFmpeg works
ffmpeg -version

# Install required fonts
sudo apt-get install fonts-dejavu

# Check disk space
df -h $VIDEO_OUT_DIR

# Review render log for details
cat video_output/*_render_log.txt
```

#### 5. "Permission denied"

**Cause**: Script not executable  
**Solution**:
```bash
chmod +x scripts/produce_videos.sh
```

### Debug Mode

Enable verbose logging:
```bash
export LOG_LEVEL="DEBUG"
python3 scripts/video_production/generate_videos.py
```

### Testing Installation

Run a quick test:
```bash
# Create test script
cat > test.md << 'EOF'
## Test Scene
This is a test video script.
EOF

# Set minimal config
export SCRIPT_PATTERN="test.md"
export VIDEO_RESOLUTION="640x480"

# Run production
./scripts/produce_videos.sh

# Check output
ls -lh video_output/test.mp4
```

## API Reference

### Python API

#### VideoConfig

```python
from pathlib import Path
from scripts.video_production.generate_videos import VideoConfig

config = VideoConfig(
    repo_root=Path("/path/to/repo"),
    script_dir=Path("/path/to/scripts"),
    script_pattern="*.md",
    demo_url=None,
    video_out_dir=Path("/path/to/output"),
    voice_mode="local_tts",
    voice_sample_wav=None,
    video_resolution="1920x1080",
    fps=30,
    llm_mode="local_llm",
    headless=True
)
```

#### VideoProductionAgent

```python
from scripts.video_production.generate_videos import VideoProductionAgent

agent = VideoProductionAgent(config)
agent.run()
```

#### Process Single Script

```python
from pathlib import Path
from scripts.video_production.generate_videos import (
    VideoProductionAgent, VideoConfig
)

config = VideoConfig.from_env()
agent = VideoProductionAgent(config)

script_path = Path("HIRING_PORTFOLIO_VIDEO.md")
job = agent.process_script(script_path)

print(f"Video: {job.final_output}")
print(f"Success: {job.final_output is not None}")
```

### Script Format Requirements

#### Heading-Based Structure (Recommended)

```markdown
## Scene 1: Introduction
Narration text for scene 1...

## Scene 2: Problem Statement
Narration text for scene 2...

### [0:30-1:00] Key Insight
Scene with explicit timecode...
```

#### Paragraph-Based (Automatic)

```markdown
This is the first scene. It will be detected automatically.

This is the second scene. The system breaks on paragraph boundaries.

Each paragraph becomes a separate scene.
```

### Best Practices

1. **Clear Structure**: Use headings for scene breaks
2. **Appropriate Length**: 50-200 words per scene
3. **Natural Language**: Write as you would speak
4. **No Jargon**: Assume non-technical audience
5. **Logical Flow**: Build narrative progressively
6. **Timing Markers**: Use timecodes for specific pacing

## Performance

### Typical Processing Times

On standard hardware (4-core CPU, 8GB RAM):

| Stage | Time per Minute | Notes |
|-------|-----------------|-------|
| Script Parsing | < 1 second | Very fast |
| Audio Generation | 2-5 seconds | Depends on TTS engine |
| Visual Generation | 1-2 seconds | Per scene |
| Video Rendering | 10-30 seconds | Depends on resolution |

**Total**: Approximately 30-60 seconds per minute of final video.

### Optimization Tips

1. **Lower Resolution**: Use 720p for faster testing
2. **Reduce FPS**: 24fps is cinematic and faster
3. **Batch Processing**: Process multiple scripts together
4. **SSD Storage**: Use SSD for output directory

## Future Enhancements

Planned features:

- [ ] Demo capture using Playwright/Selenium
- [ ] LLM-powered scene optimization
- [ ] Voice cloning from sample WAV
- [ ] Advanced diagram generation
- [ ] Subtitle/caption overlay
- [ ] Background music integration
- [ ] Transition effects between scenes
- [ ] Multi-language narration support
- [ ] Template-based visual themes
- [ ] Interactive scene previews

## License

This video production system is part of the Legion Command Center repository and is licensed under the MIT License.

## Support

For issues or questions:

1. **Check Documentation**: Review this guide and `scripts/video_production/README.md`
2. **Review Logs**: Check render logs in output directory
3. **Troubleshooting**: See troubleshooting section above
4. **Report Issues**: Open a GitHub issue with:
   - Render logs
   - Error messages
   - System information
   - Steps to reproduce

## Credits

Built with:
- **FFmpeg**: Video processing
- **espeak**: Text-to-speech
- **Python 3**: Core runtime

Created for the Gamified Coach Interface project to automate video production for portfolio and demonstration purposes.

---

**Last Updated**: 2025-12-23  
**Version**: 1.0.0  
**License**: MIT
