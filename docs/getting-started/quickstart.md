# Quickstart

This guide will get you up and running with redis-memory in minutes.

## Basic Usage

```python
from redis_memory import Memory

# Create a memory instance
mem = Memory()

# Set values like regular attributes
mem.counter = 0
mem.username = "alice"
mem.settings = {"theme": "dark", "notifications": True}

# Read values back
print(mem.counter)    # 0
print(mem.username)   # alice
print(mem.settings)   # {'theme': 'dark', 'notifications': True}
```

## Cross-Process Sharing

The real power of redis-memory is sharing state across processes:

```python
# Process 1
from redis_memory import Memory

mem = Memory()
mem.shared_value = "Hello from Process 1"
```

```python
# Process 2 (different Python process)
from redis_memory import Memory

mem = Memory()
print(mem.shared_value)  # "Hello from Process 1"
```

## Context Manager

Use `Memory` as a context manager for automatic resource cleanup:

```python
with Memory() as memory:
    memory.session = "active"
    memory.timestamp = "2025-12-24"
    print(memory.session)  # "active"

# Later, in another process:
with Memory() as memory:
    print(memory.session)  # "active"
```

## Auto-Syncing Collections

Lists and dictionaries automatically sync to Redis:

```python
mem = Memory()

# Lists
mem.tasks = ["task1", "task2"]
mem.tasks.append("task3")  # Automatically syncs!

# Dictionaries
mem.config = {"lang": "en"}
mem.config["theme"] = "dark"  # Automatically syncs!

# Nested structures work too!
mem.data = {"user": {"name": "Alice", "age": 30}}
mem.data["user"]["age"] = 31  # Syncs the entire structure
```

## Converting to Plain Types

When you need regular Python objects (for serialization, pickling, etc.):

```python
mem.items = [1, 2, 3]
plain_list = mem.items.aslist()  # Returns: [1, 2, 3]

mem.config = {"key": "value"}
plain_dict = mem.config.asdict()  # Returns: {'key': 'value'}

# Now you can use with libraries that need plain types
import pickle
pickle.dump(plain_list, open('data.pkl', 'wb'))
```

## Next Steps

- Learn about [basic usage patterns](../guide/basic-usage.md)
- Explore [auto-synced collections](../guide/collections.md)
- Set up [namespacing](../guide/namespacing.md) for multi-tenant apps
- Use [agent memory](../guide/agents.md) for conversational AI
