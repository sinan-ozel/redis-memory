# API Reference

Complete API documentation for redis-memory.

## Classes

### Memory

::: redis_memory.Memory
    options:
      show_root_heading: true
      show_source: true
      heading_level: 3

### ConversationMemory

::: redis_memory.ConversationMemory
    options:
      show_root_heading: true
      show_source: true
      heading_level: 3

### SyncedList

::: redis_memory.SyncedList
    options:
      show_root_heading: true
      show_source: true
      heading_level: 3

### SyncedDict

::: redis_memory.SyncedDict
    options:
      show_root_heading: true
      show_source: true
      heading_level: 3

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `REDIS_HOST` | `redis` | Redis server hostname |
| `REDIS_PORT` | `6379` | Redis server port |
| `REDIS_PREFIX` | `memory:` | Key prefix for namespacing |
| `MEMORY_LOG_LEVEL` | `WARNING` | Logging level (DEBUG, INFO, WARNING, ERROR) |

## Exceptions

redis-memory uses standard Python exceptions and Redis exceptions:

- `AttributeError`: Raised when accessing non-existent attributes
- `redis.ConnectionError`: Raised when Redis connection fails
- `redis.TimeoutError`: Raised when Redis operations timeout

## Type Hints

redis-memory supports type hints:

```python
from redis_memory import Memory
from typing import List, Dict, Any

mem: Memory = Memory()
mem.items: List[int] = [1, 2, 3]
mem.config: Dict[str, Any] = {"key": "value"}
```
