
import { describe, it, expect, vi, beforeEach } from 'vitest';
import fs from 'fs';
import path from 'path';

// Mock DOM
const html = fs.readFileSync(path.resolve(__dirname, '../../legion-v3.html'), 'utf8');

describe('Boot Screen Accessibility', () => {
  beforeEach(() => {
    document.body.innerHTML = html;
  });

  it('should have a progress bar with correct ARIA attributes', () => {
    const progressContainer = document.querySelector('.boot-progress');

    expect(progressContainer).toBeTruthy();
    expect(progressContainer.getAttribute('role')).toBe('progressbar');
    expect(progressContainer.getAttribute('aria-label')).toBe('System Boot Progress');
    expect(progressContainer.getAttribute('aria-valuemin')).toBe('0');
    expect(progressContainer.getAttribute('aria-valuemax')).toBe('100');
  });

  it('should have the boot screen element', () => {
      const bootScreen = document.getElementById('boot-screen');
      expect(bootScreen).toBeTruthy();
  });
});
