# Basic Usage

## Creating a Memory Instance

```python
from redis_memory import Memory

mem = Memory()
```

By default, `Memory` connects to Redis at `redis:6379` and uses the prefix `memory:`.

## Setting Values

Set values using attribute assignment:

```python
mem.counter = 42
mem.name = "Alice"
mem.active = True
mem.score = 98.5
mem.items = [1, 2, 3]
mem.config = {"theme": "dark", "lang": "en"}
```

All values are automatically serialized to JSON and stored in Redis.

## Getting Values

Retrieve values using attribute access:

```python
print(mem.counter)  # 42
print(mem.name)     # Alice
print(mem.active)   # True
print(mem.items)    # [1, 2, 3]
```

## Checking if Attributes Exist

Use `hasattr()` or try/except:

```python
if hasattr(mem, 'counter'):
    print(f"Counter exists: {mem.counter}")

try:
    value = mem.nonexistent
except AttributeError:
    print("Attribute doesn't exist")
```

## Deleting Values

Delete attributes using `del`:

```python
mem.temp = "temporary"
del mem.temp
# Now mem.temp raises AttributeError
```

## Working with Complex Data

redis-memory handles complex nested structures:

```python
mem.user = {
    "name": "Alice",
    "profile": {
        "age": 30,
        "preferences": {
            "theme": "dark",
            "notifications": ["email", "push"]
        }
    }
}

# Access nested data
print(mem.user["profile"]["age"])  # 30
```

## Persistence

Values persist across program restarts:

```python
# Run 1
mem = Memory()
mem.persistent_value = "I will survive!"

# Later, after program restart
mem = Memory()
print(mem.persistent_value)  # "I will survive!"
```

## Multiprocessing Safety

redis-memory is safe to use across multiple processes:

```python
from multiprocessing import Process
from redis_memory import Memory

def worker(worker_id):
    mem = Memory()
    mem.counter = getattr(mem, 'counter', 0) + 1
    print(f"Worker {worker_id}: counter = {mem.counter}")

processes = [Process(target=worker, args=(i,)) for i in range(5)]
for p in processes:
    p.start()
for p in processes:
    p.join()

# Each process sees the shared counter
```

## Redis Connection Resilience

If Redis is temporarily unavailable:

```python
mem = Memory()
# If Redis is down, changes are queued locally
mem.offline_value = "queued"

# When Redis comes back online, queued changes are automatically synced
```

## Performance Tips

1. **Batch operations**: Group multiple changes together when possible
2. **Use appropriate data structures**: Lists and dicts are auto-synced on modification
3. **Minimize Redis roundtrips**: Read once, modify locally, write back
4. **Consider caching**: For read-heavy workloads, cache frequently accessed values

## Error Handling

```python
from redis_memory import Memory
import redis

try:
    mem = Memory()
    mem.value = "test"
except redis.ConnectionError:
    print("Failed to connect to Redis")
except Exception as e:
    print(f"Unexpected error: {e}")
```
