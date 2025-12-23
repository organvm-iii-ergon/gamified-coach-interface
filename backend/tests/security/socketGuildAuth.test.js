
const { sequelize } = require('../../config/database');

// Mock Sequelize and Database
jest.mock('../../config/database', () => {
  const mSequelize = {
    authenticate: jest.fn().mockResolvedValue(true),
    sync: jest.fn().mockResolvedValue(true),
    close: jest.fn().mockResolvedValue(true),
    define: jest.fn(() => ({
      belongsToMany: jest.fn(),
      hasMany: jest.fn(),
      belongsTo: jest.fn(),
      prototype: {},
    })),
  };
  return { sequelize: mSequelize };
});

// Mock Socket.IO
// We need to capture the 'connection' handler so we can simulate a connection
let connectionHandler;
const mockSocketIo = jest.fn().mockImplementation(() => {
    return {
        use: jest.fn(),
        on: jest.fn((event, handler) => {
            if (event === 'connection') {
                connectionHandler = handler;
            }
        }),
        to: jest.fn().mockReturnThis(),
        emit: jest.fn(),
    };
});

jest.mock('socket.io', () => mockSocketIo);

// Import server (this will execute the io.on('connection') code)
const { app, io, server } = require('../../server');

describe('Socket Security: Guild Authorization', () => {
  let mockSocket;
  let guildMessageHandler;

  beforeAll(() => {
    // We expect connectionHandler to be set when server.js is required
    expect(connectionHandler).toBeDefined();
  });

  afterAll(async () => {
    if (server && server.listening) {
      server.close();
    }
  });

  beforeEach(() => {
    // Create a mock socket
    mockSocket = {
      id: 'socket-123',
      join: jest.fn(),
      on: jest.fn((event, handler) => {
        if (event === 'guild_message') {
          guildMessageHandler = handler;
        }
      }),
      emit: jest.fn(),
      user: {
        id: 'user-123',
        username: 'Hacker',
        // User is member of guild 100, but NOT guild 999
        guilds: [100]
      }
    };

    // Simulate connection
    connectionHandler(mockSocket);
  });

  it('should allow sending message to a guild the user is a member of', async () => {
    const data = { guildId: 100, message: 'Hello Guild 100' };

    // Clear mocks
    io.to.mockClear();
    io.emit.mockClear();

    await guildMessageHandler(data);

    // Verify it broadcasted
    expect(io.to).toHaveBeenCalledWith('guild:100');
    // Note: io.to returns 'this', then emit is called.
    // Since we mocked to() to return 'this' (the io instance), we can check if emit was called?
    // Actually the mock implementation in health.test.js says `emit: jest.fn()`.
    // Wait, `io.to().emit()` calls `emit` on the object returned by `to()`.
    // In our mock, `to()` returns `this`, so `io.emit` should be called.
    // However, `io` is the instance returned by `socketIo()`.
    // Let's check `io.emit` calls. But wait, `emit` is called on the result of `to()`.
    // If `to()` returns `io` (which it does via mockReturnThis()), then `io.emit` is called.
    // But verify the args.

    // Wait, the emit in server.js is:
    // io.to(...).emit('new_guild_message', ...)

    // The mock for `emit` is on the io instance.
    // So yes, `io.emit` should be called.
    expect(io.emit).toHaveBeenCalledWith('new_guild_message', expect.objectContaining({
        message: 'Hello Guild 100',
        senderId: 'user-123'
    }));
  });

  it('should NOT allow sending message to a guild the user is NOT a member of', async () => {
    const data = { guildId: 999, message: 'Hacked Message' };

    // Clear mocks
    io.to.mockClear();
    io.emit.mockClear();

    // This should ideally throw or just not emit.
    // Currently, it WILL emit because of the vulnerability.
    await guildMessageHandler(data);

    // This expectation should FAIL if the vulnerability exists
    expect(io.to).not.toHaveBeenCalledWith('guild:999');
    expect(io.emit).not.toHaveBeenCalledWith('new_guild_message', expect.anything());
  });
});
