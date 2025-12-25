# Auto-Synced Collections

redis-memory automatically wraps lists and dictionaries to keep them synchronized with Redis. Any modifications to these collections are immediately persisted.

## Auto-Synced Lists

### Basic Operations

```python
from redis_memory import Memory

mem = Memory()
mem.tasks = [1, 2, 3]

# All list operations sync automatically
mem.tasks.append(4)        # [1, 2, 3, 4]
mem.tasks.extend([5, 6])   # [1, 2, 3, 4, 5, 6]
mem.tasks.insert(0, 0)     # [0, 1, 2, 3, 4, 5, 6]

# Check in another process
mem2 = Memory()
print(mem2.tasks)  # [0, 1, 2, 3, 4, 5, 6]
```

### Supported Operations

The following list operations automatically sync:

- `append(item)`: Add item to end
- `extend(iterable)`: Add multiple items
- `insert(index, item)`: Insert at position
- `remove(item)`: Remove first occurrence
- `pop([index])`: Remove and return item
- `clear()`: Remove all items
- `sort()`: Sort in place
- `reverse()`: Reverse in place

### Item Assignment

```python
mem.items = [1, 2, 3]
mem.items[0] = 10  # [10, 2, 3] - syncs automatically
mem.items[1:3] = [20, 30]  # [10, 20, 30] - syncs automatically
```

## Auto-Synced Dictionaries

### Basic Operations

```python
mem = Memory()
mem.config = {"theme": "dark", "lang": "en"}

# All dict operations sync automatically
mem.config["notifications"] = True
mem.config.update({"font": "Arial", "size": 12})

# Check in another process
mem2 = Memory()
print(mem2.config)
# {'theme': 'dark', 'lang': 'en', 'notifications': True, 'font': 'Arial', 'size': 12}
```

### Supported Operations

The following dict operations automatically sync:

- `__setitem__(key, value)`: Set a key
- `__delitem__(key)`: Delete a key
- `pop(key)`: Remove and return value
- `popitem()`: Remove and return (key, value) pair
- `clear()`: Remove all items
- `update(other)`: Update with another dict
- `setdefault(key, default)`: Set if not exists

### Nested Access

```python
mem.data = {"user": {"name": "Alice", "age": 30}}

# Direct modification syncs the entire structure
mem.data["user"]["age"] = 31
print(mem.data)  # {'user': {'name': 'Alice', 'age': 31}}
```

## Nested Collections

redis-memory handles deeply nested structures:

```python
mem = Memory()
mem.complex = {
    "users": [
        {"name": "Alice", "scores": [95, 87, 92]},
        {"name": "Bob", "scores": [88, 91, 85]}
    ],
    "settings": {
        "theme": "dark",
        "notifications": {
            "email": True,
            "push": False
        }
    }
}

# Modifications at any level sync automatically
mem.complex["users"][0]["scores"].append(96)
mem.complex["settings"]["notifications"]["push"] = True

# Check in another process
mem2 = Memory()
print(mem2.complex["users"][0]["scores"])  # [95, 87, 92, 96]
print(mem2.complex["settings"]["notifications"]["push"])  # True
```

## Converting to Plain Python Types

Sometimes you need regular Python lists/dicts (for pickling, JSON serialization, etc.):

### Converting Lists

```python
mem = Memory()
mem.items = [1, 2, 3]

# Convert to plain list
plain_list = mem.items.aslist()
print(type(plain_list))  # <class 'list'>

# Now you can use with any library
import pickle
pickle.dump(plain_list, open('data.pkl', 'wb'))
```

### Converting Dictionaries

```python
mem = Memory()
mem.config = {"key": "value", "nested": {"a": 1}}

# Convert to plain dict
plain_dict = mem.config.asdict()
print(type(plain_dict))  # <class 'dict'>

# Works with nested structures too
print(type(plain_dict["nested"]))  # <class 'dict'>
```

### Recursive Conversion

Both `aslist()` and `asdict()` recursively convert nested structures:

```python
mem.data = {
    "items": [1, 2, {"nested": [3, 4]}],
    "config": {"x": [5, 6]}
}

plain = mem.data.asdict()
# All nested SyncedList and SyncedDict objects are converted
# to plain list and dict objects
```

## Performance Considerations

### Sync Frequency

Every modification triggers a sync to Redis. For bulk operations, consider:

```python
# Less efficient (multiple syncs)
for i in range(1000):
    mem.items.append(i)  # 1000 Redis writes

# More efficient (one sync)
new_items = list(range(1000))
mem.items = mem.items.aslist() + new_items  # 1 Redis write
```

### Large Collections

For very large collections, consider:

1. **Pagination**: Split large lists into smaller chunks
2. **Compression**: Use Redis compression if available
3. **Alternative structures**: Use Redis native data structures for specific use cases

## Type Checking

You can check if an object is synced:

```python
from redis_memory import SyncedList, SyncedDict

mem = Memory()
mem.items = [1, 2, 3]
mem.config = {"key": "value"}

isinstance(mem.items, SyncedList)   # True
isinstance(mem.config, SyncedDict)  # True

# Plain types after conversion
plain_list = mem.items.aslist()
isinstance(plain_list, SyncedList)  # False
isinstance(plain_list, list)        # True
```

## Limitations

!!! warning "Copy vs Reference"
    When you extract a nested collection, modifications to the extracted reference may not sync:

    ```python
    mem.data = {"items": [1, 2, 3]}
    items_ref = mem.data["items"]
    items_ref.append(4)  # May not sync reliably

    # Instead, modify in place:
    mem.data["items"].append(4)  # Syncs correctly
    ```

!!! tip "Best Practice"
    Always modify collections through the memory object's attribute chain to ensure syncing works correctly.
