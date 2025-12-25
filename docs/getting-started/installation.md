# Installation

## Requirements

- Python 3.8+
- Redis server (local or remote)
- Docker (optional, for development)

## Install from PyPI

The easiest way to install redis-memory is from PyPI:

```bash
pip install redis-memory
```

## Install from Source

If you want to install from source:

```bash
git clone https://github.com/sinan-ozel/redis-memory.git
cd redis-memory
pip install .
```

## Redis Setup

redis-memory requires a Redis server to be running. You can:

### Option 1: Use Docker

```bash
docker run -d -p 6379:6379 redis:latest
```

### Option 2: Install Redis Locally

**macOS:**
```bash
brew install redis
brew services start redis
```

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install redis-server
sudo systemctl start redis-server
```

**Windows:**
Download and install from [Redis for Windows](https://github.com/microsoftarchive/redis/releases)

## Environment Variables

Configure redis-memory using environment variables:

- `REDIS_HOST`: Redis server hostname (default: `redis`)
- `REDIS_PORT`: Redis server port (default: `6379`)
- `REDIS_PREFIX`: Key prefix for namespacing (default: `memory:`)

Example `.env` file:

```env
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PREFIX=myapp:
```

## Verify Installation

Test that everything is working:

```python
from redis_memory import Memory

mem = Memory()
mem.test = "Hello, Redis!"
print(mem.test)  # Should print: Hello, Redis!
```

If you see the output, you're all set! 🎉
