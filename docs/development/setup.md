# Development Setup

Complete guide to setting up your development environment for redis-memory.

## Prerequisites

Before you begin, ensure you have:

- **Docker**: Required for all development workflows
- **Git**: For version control
- **VS Code**: Optional but highly recommended

### Installing Docker

**macOS:**
```bash
brew install --cask docker
```

**Windows:**
Download from [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop)

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get update
sudo apt-get install docker.io docker-compose
sudo usermod -aG docker $USER
# Log out and back in
```

## Setup Options

### Option 1: VS Code Dev Containers (Recommended)

This is the easiest and most consistent setup.

**Step 1: Install VS Code Extensions**

Install the "Dev Containers" extension:
1. Open VS Code
2. Press `Cmd/Ctrl + Shift + X`
3. Search for "Dev Containers"
4. Install the extension by Microsoft

**Step 2: Open in Container**

1. Open the redis-memory project in VS Code
2. Press `Cmd/Ctrl + Shift + P`
3. Select "Dev Containers: Reopen in Container"
4. Wait for the container to build (first time takes a few minutes)

**Step 3: You're Done!**

The devcontainer includes:
- Python 3.11
- Redis server (automatically started)
- All dependencies pre-installed
- Pre-configured VS Code settings

### Option 2: Docker Compose

Use Docker without VS Code.

**Run Tests:**
```bash
cd tests
docker-compose up --build --abort-on-container-exit --exit-code-from test
```

**Reformat Code:**
```bash
docker compose -f reformat/docker-compose.yml up --build --abort-on-container-exit
```

**Validate Docs:**
```bash
docker compose -f docs-validate/docker-compose.yml up --build --abort-on-container-exit
```

### Option 3: Virtual Environment

For those who prefer local Python environments.

**Step 1: Create Virtual Environment**

```bash
python3 -m venv .venv
```

**Step 2: Activate**

```bash
# macOS/Linux
source .venv/bin/activate

# Windows
.venv\Scripts\activate
```

**Step 3: Install Dependencies**

```bash
pip install --upgrade pip
pip install -e .
pip install -e .[test]
pip install -e .[dev]
pip install -e .[docs]
```

**Step 4: Start Redis**

You'll need Redis running locally:

```bash
# macOS
brew install redis
brew services start redis

# Ubuntu/Debian
sudo apt-get install redis-server
sudo systemctl start redis-server

# Docker
docker run -d -p 6379:6379 redis:latest
```

## Verifying Your Setup

### Test the Installation

```python
from redis_memory import Memory

mem = Memory()
mem.test = "Hello, World!"
print(mem.test)  # Should print: Hello, World!
```

### Run the Test Suite

**In Dev Container or with Virtual Environment:**
```bash
cd tests
pytest -v
```

**Using Docker:**
```bash
cd tests
docker-compose up --build
```

### Check Code Formatting

```bash
black --check src/
isort --check src/
ruff check src/
```

## VS Code Tasks

The project includes pre-configured VS Code tasks:

Access tasks: `Cmd/Ctrl + Shift + P` → "Tasks: Run Task"

Available tasks:
- **Run Unit Tests (Run inside the .devcontainer)**: Run tests with pytest
- **Run Unit Tests in Docker**: Run tests in isolated Docker environment
- **Reformat Code**: Auto-format code with black, docformatter, and isort
- **Reformat and Lint**: Format and run linter
- **validate-docs**: Validate documentation

## Environment Variables

Create a `.env` file for local development:

```env
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PREFIX=dev:
MEMORY_LOG_LEVEL=DEBUG
```

Load it in your code:

```python
from dotenv import load_dotenv
load_dotenv()

from redis_memory import Memory
mem = Memory()
```

## Project Structure

```
redis-memory/
├── .devcontainer/          # Dev container configuration
├── .github/
│   └── workflows/
│       └── ci.yaml         # CI/CD pipeline
├── .vscode/
│   └── tasks.json          # VS Code tasks
├── docs/                   # Documentation source
├── docs-validate/          # Docs validation Docker setup
├── reformat/               # Code formatting Docker setup
├── scripts/                # Utility scripts
├── src/
│   └── redis_memory/
│       └── __init__.py     # Main source code
├── tests/
│   ├── test_memory.py      # Test suite
│   └── docker-compose.yaml # Test environment
├── mkdocs.yml              # Documentation config
└── pyproject.toml          # Project metadata
```

## Common Issues

### Redis Connection Error

**Problem:** `redis.exceptions.ConnectionError: Error connecting to Redis`

**Solution:**
- Ensure Redis is running: `redis-cli ping` should return `PONG`
- Check `REDIS_HOST` environment variable
- Verify Redis port (default: 6379)

### Import Errors

**Problem:** `ModuleNotFoundError: No module named 'redis_memory'`

**Solution:**
```bash
# Install in editable mode
pip install -e .
```

### Docker Permission Errors

**Problem:** Permission denied on Docker commands

**Solution:**
```bash
# Linux: Add user to docker group
sudo usermod -aG docker $USER
# Log out and back in
```

### Port Already in Use

**Problem:** `Port 6379 already in use`

**Solution:**
```bash
# Find and kill the process
lsof -i :6379
kill -9 <PID>

# Or use a different port
export REDIS_PORT=6380
```

## Next Steps

Once your environment is set up:

1. Read the [Contributing Guide](contributing.md)
2. Look for [good first issues](https://github.com/sinan-ozel/redis-memory/labels/good%20first%20issue)
3. Join discussions on GitHub
4. Start coding! 🚀
