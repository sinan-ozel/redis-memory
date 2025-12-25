# Contributing

Thank you for your interest in contributing to redis-memory! This guide will help you get started.

## Getting Started

### Prerequisites

- Docker (required)
- Git
- VS Code (optional, but recommended for devcontainer support)

### Fork and Clone

1. Fork the repository on GitHub
2. Clone your fork:

```bash
git clone https://github.com/YOUR_USERNAME/redis-memory.git
cd redis-memory
```

## Development Environment

### Option 1: VS Code Dev Containers (Recommended)

1. Open the project in VS Code
2. Install the "Dev Containers" extension
3. Press `Cmd/Ctrl + Shift + P` and select "Dev Containers: Reopen in Container"
4. Wait for the container to build

Everything is pre-configured! Redis, Python, and all dependencies are ready.

### Option 2: Docker Compose

Run tests without installing anything:

```bash
cd tests
docker-compose up --build --remove-orphans --force-recreate --abort-on-container-exit --exit-code-from test
```

### Option 3: Local Virtual Environment

```bash
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

pip install --upgrade pip
pip install -e .
pip install -e .[test]
pip install -e .[dev]
pip install -e .[docs]
```

## Development Workflow

### 1. Create a Branch

```bash
git checkout -b feature/your-feature-name
```

Use prefixes:
- `feature/` for new features
- `bugfix/` for bug fixes
- `docs/` for documentation changes
- `refactor/` for refactoring

### 2. Make Changes

Write your code following the project's style:

```python
# Good: Clear, documented, type-hinted
def calculate_sum(a: int, b: int) -> int:
    """Calculate the sum of two integers.

    Args:
        a: First integer
        b: Second integer

    Returns:
        The sum of a and b
    """
    return a + b
```

### 3. Write Tests

Add tests for your changes in `tests/test_memory.py`:

```python
def test_your_feature():
    """Test your new feature."""
    mem = Memory()
    mem.value = "test"
    assert mem.value == "test"
```

### 4. Run Tests

**Using VS Code Tasks:**
- `Cmd/Ctrl + Shift + P` → "Tasks: Run Task"
- Select "Run Unit Tests"

**Using Docker:**
```bash
cd tests
docker-compose up --build --abort-on-container-exit
```

**Using pytest directly (in devcontainer or venv):**
```bash
cd tests
pytest -v
```

### 5. Format and Lint

**Using VS Code Tasks:**
- Select "Reformat Code" task

**Using Docker:**
```bash
docker compose -f reformat/docker-compose.yml up --build --abort-on-container-exit
```

**Manually (in devcontainer or venv):**
```bash
black src/
docformatter --in-place --recursive src/
isort src/
ruff check src/
```

### 6. Commit

Write clear commit messages:

```bash
git add .
git commit -m "feat: add support for nested dictionary updates

- Added recursive sync for nested SyncedDict objects
- Updated tests to cover nested scenarios
- Fixed edge case with None values
```

Use conventional commit prefixes:
- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation
- `test:` for tests
- `refactor:` for refactoring
- `chore:` for maintenance

### 7. Push and Create PR

```bash
git push origin feature/your-feature-name
```

Go to GitHub and create a Pull Request with:
- Clear title describing the change
- Description of what and why
- Link to related issues
- Screenshots if UI-related

## Code Style

### Python Style

- Follow PEP 8
- Use type hints
- Write docstrings (Google style)
- Max line length: 80 characters
- Use `black` for formatting

### Docstrings

```python
def function_name(param1: str, param2: int) -> bool:
    """Short description of the function.

    Longer description if needed. Explain the purpose,
    behavior, and any important details.

    Args:
        param1: Description of param1
        param2: Description of param2

    Returns:
        Description of return value

    Raises:
        ValueError: When and why this is raised
    """
    pass
```

## Testing Guidelines

- Write tests for all new features
- Maintain or improve code coverage
- Test edge cases and error conditions
- Use descriptive test names
- Keep tests independent

## Pull Request Review

Your PR will be reviewed for:

1. **Functionality**: Does it work as intended?
2. **Tests**: Are there adequate tests?
3. **Code Quality**: Is it clean and maintainable?
4. **Documentation**: Is it documented?
5. **Style**: Does it follow the style guide?

## Getting Help

- Open an issue for questions
- Join discussions on GitHub
- Check existing issues and PRs

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Recognition

Contributors are recognized in:
- GitHub contributors list
- Release notes
- Project README

Thank you for contributing! 🎉
