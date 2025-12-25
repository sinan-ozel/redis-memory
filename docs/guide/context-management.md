# Context Management

redis-memory supports Python's context manager protocol, allowing you to use it with `with` statements for automatic resource management.

## Basic Usage

```python
from redis_memory import Memory

with Memory() as memory:
    memory.session = "active"
    memory.user_id = 12345
    print(memory.session)  # "active"
```

## Benefits of Context Managers

1. **Automatic cleanup**: Resources are properly released when the context exits
2. **Exception safety**: Cleanup occurs even if exceptions are raised
3. **Clear scope**: Makes the lifetime of the memory object explicit

## Nested Contexts

You can nest context managers:

```python
with Memory() as mem1:
    mem1.outer = "outer value"

    with Memory() as mem2:
        mem2.inner = "inner value"
        print(mem1.outer)  # "outer value"
        print(mem2.outer)  # "outer value" (same Redis backend)
```

## Exception Handling

Context managers work seamlessly with exception handling:

```python
try:
    with Memory() as memory:
        memory.status = "processing"
        # Some operation that might fail
        result = risky_operation()
        memory.status = "completed"
except Exception as e:
    print(f"Operation failed: {e}")
    # memory is properly cleaned up
```

## Long-Running Contexts

For long-running applications, you might use a context manager at the application level:

```python
def main():
    with Memory() as memory:
        memory.app_state = "running"

        # Your application logic
        while memory.app_state == "running":
            process_events()

        memory.app_state = "stopped"

if __name__ == "__main__":
    main()
```

## Combining with Other Context Managers

redis-memory works well with other context managers:

```python
from redis_memory import Memory
import logging

with Memory() as memory, \
     open('log.txt', 'w') as log_file:

    memory.session_id = "abc123"
    log_file.write(f"Session: {memory.session_id}\n")

    # Both resources are properly managed
```

## Async Context Managers

If you're using async code, you can still use Memory, but be aware that the Redis operations themselves are synchronous:

```python
import asyncio
from redis_memory import Memory

async def async_task():
    with Memory() as memory:
        memory.task_status = "running"
        await asyncio.sleep(1)
        memory.task_status = "completed"

asyncio.run(async_task())
```

!!! note
    redis-memory does not currently provide native async support. The Redis operations are blocking, so consider using them outside of async critical paths.

## Without Context Managers

You don't have to use context managers. Direct instantiation works fine:

```python
mem = Memory()
mem.value = "test"
# Memory object lives until garbage collected
```

The context manager is purely optional and provides a cleaner, more explicit way to manage the memory object's lifetime.
