
import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest';

// Setup globals before any imports that might use them
// But since we can't guarantee order with static imports, we use dynamic import for the module under test.
global.document = {
    addEventListener: vi.fn(),
    getElementById: vi.fn(),
    querySelectorAll: vi.fn(() => []),
    activeElement: null
};
global.window = {
    addEventListener: vi.fn()
};

// Mock SceneManager
vi.mock('../SceneManager.js', () => {
    return {
        SceneManager: class {
            constructor() {}
            getOrbitalNodes() { return { deactivateNode: vi.fn() }; }
            setCoreStat() {}
        }
    };
});

describe('Boot Sequence Accessibility', () => {
    let mockBootScreen;
    let mockBootBar;
    let mockBootProgress;
    let LegionCommandCenter;

    beforeEach(async () => {
        vi.useFakeTimers();

        mockBootScreen = { classList: { add: vi.fn() } };
        mockBootBar = { style: {} };
        mockBootProgress = {
            setAttribute: vi.fn(),
            style: {}
        };

        global.document.getElementById = vi.fn((id) => {
            if (id === 'boot-screen') return mockBootScreen;
            if (id === 'boot-bar') return mockBootBar;
            if (id === 'boot-progress-container') return mockBootProgress;
            // Return a default mock for other elements to prevent crash (e.g. close-terminal button)
            return {
                addEventListener: vi.fn(),
                classList: { remove: vi.fn(), add: vi.fn() },
                focus: vi.fn()
            };
        });

        global.localStorage = {
            getItem: vi.fn(),
            setItem: vi.fn()
        };

        // Import dynamically to ensure globals are set
        // We use a query parameter to bypass cache if needed, but vitest should handle it
        const module = await import('../main.js');
        LegionCommandCenter = module.LegionCommandCenter;
    });

    afterEach(() => {
        vi.restoreAllMocks();
        vi.resetModules();
    });

    it('should update aria-valuenow on progress container during boot', async () => {
        const app = new LegionCommandCenter();

        // Fast-forward time to simulate progress
        // The interval is 200ms
        await vi.advanceTimersByTimeAsync(200);

        expect(mockBootProgress.setAttribute).toHaveBeenCalledWith('aria-valuenow', expect.any(Number));

        // Check that value is within range
        const callArgs = mockBootProgress.setAttribute.mock.calls[0];
        const value = callArgs[1];
        expect(value).toBeGreaterThanOrEqual(0);
        expect(value).toBeLessThanOrEqual(100);

        // Advance to completion (approx 100% / (7.5 avg increment) * 200ms = ~2600ms)
        await vi.advanceTimersByTimeAsync(3000);

        // Should eventually reach 100
        expect(mockBootProgress.setAttribute).toHaveBeenCalledWith('aria-valuenow', 100);
    });
});
