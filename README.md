![Tests & Lint](https://github.com/sinan-ozel/redis-memory/actions/workflows/ci.yaml/badge.svg?branch=main)
![PyPI](https://img.shields.io/pypi/v/redis-memory.svg)
![Downloads](https://static.pepy.tech/badge/redis-memory)
![Monthly Downloads](https://static.pepy.tech/badge/redis-memory/month)
![License](https://img.shields.io/github/license/sinan-ozel/redis-memory.svg)


# 🗄️ redis-memory

A Python class for seamless, multiprocessing-safe, persistent key-value storage
using Redis as a backend. If Redis is unavailable, values are cached locally
and queued for syncing when Redis comes back online. All values are serialized
as JSON, and you interact with it using natural Python attribute access.

The intention is to use this with agentic workflows deployed as microservices,
allowing for multiple instances of the same pod. (Hence the name ``memory'')
That said, this is probably a good alternative for state management in
microservice architecture where multiple pods are deployed in parallel.

## ✨ Features

- 🔄 **Multiprocessing-safe**: All processes share the same state via Redis.
- 🧠 **Pythonic API**: Set and get attributes as if they were regular object properties.
- 🕰️ **Persistence**: Values survive process restarts and context blocks.
- 🚦 **Resilient**: If Redis is down, changes are queued and flushed when it returns.
- 🧩 **Customizable**: Prefixes and conversation IDs for namespacing.
- 🧵 **Background sync**: Queued changes are flushed automatically in the background.

## 🚀 Quickstart

```bash
pip install redis-memory
```


```python
from redis_memory import Memory

mem = Memory()
mem.answer = 42
print(mem.answer)  # 42

# Across processes or instances:
mem2 = Memory()
print(mem2.answer)  # 42

mem.settings = {"theme": "dark", "volume": 0.75}
print(mem.settings)  # {'theme': 'dark', 'volume': 0.75}
```

## 🧑‍💻 Context Management

You can use `Memory` as a context manager for automatic resource handling:

```python
with Memory() as memory:
    memory.session = "active"
    print(memory.session)  # "active"

# Later, in a new context:
with Memory() as memory:
    print(memory.session)  # "active"
```

## 🗂️ Namespacing with ConversationMemory

For chatbots or multi-user apps, use `ConversationMemory` to isolate keys:

```python
from redis_memory import ConversationMemory

conv_mem = ConversationMemory(conversation_id="user123")
conv_mem.state = {"step": 1}
print(conv_mem.state)  # {'step': 1}
```

## ⚙️ Environment Variables

- `REDIS_HOST`: Redis server hostname (default: `redis`)
- `REDIS_PORT`: Redis server port (default: `6379`)
- `REDIS_PREFIX`: Key prefix (default: `memory:`)

## 🛠️ Development

### 🐳 Docker/Devcontainer

- Clone the repo.
- You can use [VS Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers) for an instant dev environment.
- Or, just run tests in Docker—no setup needed!

### 🧪 Running Tests

**With a Development Container**: Open in VS Code, and start the development
container. You do not need to install anything other than VS Code and docker.
(Shift/Cmd + P and check under ``Dev Containers'')

Run the two VS code tasks, test and reformat, before making a PR. These are
the same as the tests that will run on the CI/CD pipeline.

**Without Anything**: Just write the code, and add your unit tests.
(Test-Driven Development)
Run the following command:
```bash
docker-compose up --build --remove-orphans --force-recreate --abort-on-container-exit --exit-code-from test
```

The only requirement is `docker`.

**Virtual Env**: I did not add support for the Python `venv`. However, all of
the requirements are captured in pyproject.toml. You _should_ be able to use the
following commands to set up a venv with all of the requirements.

```bash
python -m venv .venv
source .venv/bin/activate       # macOS/Linux
.venv\Scripts\activate          # Windows

pip install --upgrade pip
pip install .
pip install .[test]
pip install .[dev]
```


### 🤝 Contributing

- PRs are welcome! No special permissions required.
- All you need is Docker (or a devcontainer).
- Please ensure all tests pass before submitting your PR.

## 📚 License

MIT

---

Made with ❤️ and Redis.
