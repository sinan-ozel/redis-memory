# Namespacing

redis-memory supports namespacing through prefixes, allowing multiple applications or tenants to share the same Redis instance without key collisions.

## Default Prefix

By default, redis-memory uses `memory:` as the key prefix:

```python
from redis_memory import Memory

mem = Memory()
mem.counter = 1
# Stored in Redis as: memory:counter
```

## Custom Prefix via Environment Variable

Set the `REDIS_PREFIX` environment variable to customize the prefix:

```bash
export REDIS_PREFIX="myapp:"
```

```python
from redis_memory import Memory

mem = Memory()
mem.counter = 1
# Stored in Redis as: myapp:counter
```

## Using .env Files

Create a `.env` file:

```env
REDIS_PREFIX=myapp:
REDIS_HOST=localhost
REDIS_PORT=6379
```

Load it in your application:

```python
from dotenv import load_dotenv
load_dotenv()

from redis_memory import Memory

mem = Memory()
mem.value = "test"
# Uses the prefix from .env
```

## Multi-Tenant Applications

Use different prefixes for different tenants:

```python
import os
from redis_memory import Memory

# Tenant 1
os.environ['REDIS_PREFIX'] = 'tenant1:'
mem1 = Memory()
mem1.data = "tenant 1 data"

# Tenant 2
os.environ['REDIS_PREFIX'] = 'tenant2:'
mem2 = Memory()
mem2.data = "tenant 2 data"

# Data is isolated
print(mem1.data)  # "tenant 1 data"
print(mem2.data)  # "tenant 2 data"
```

## Environment-Based Prefixes

Use different prefixes for different environments:

```python
import os
from redis_memory import Memory

env = os.getenv('ENVIRONMENT', 'development')
os.environ['REDIS_PREFIX'] = f'{env}:'

mem = Memory()
mem.config = {"env": env}
# development: -> development:config
# staging: -> staging:config
# production: -> production:config
```

## Best Practices

1. **Use descriptive prefixes**: `myapp:prod:` is better than `mp:`
2. **Include environment**: `myapp:dev:`, `myapp:staging:`, `myapp:prod:`
3. **Add tenant IDs**: `myapp:tenant_123:` for multi-tenancy
4. **Avoid special characters**: Stick to alphanumeric and underscores
5. **End with colon**: `myapp:` makes keys more readable

## Key Structure Examples

Good prefix patterns:

```
myapp:                          # Simple application
myapp:dev:                      # With environment
myapp:prod:user_123:           # With tenant ID
analytics:session:abc123:      # Service + session
cache:v2:                      # With version
```

## Inspecting Keys in Redis

View all keys for a prefix:

```bash
# In Redis CLI
redis-cli KEYS "myapp:*"
```

Or in Python:

```python
import redis

r = redis.Redis(host='localhost', port=6379)
keys = r.keys('myapp:*')
for key in keys:
    print(key.decode('utf-8'))
```

## Cleaning Up a Namespace

Remove all keys for a specific prefix:

```bash
# Careful! This deletes all matching keys
redis-cli --scan --pattern "myapp:*" | xargs redis-cli DEL
```

Or in Python:

```python
import redis

r = redis.Redis(host='localhost', port=6379)
keys = r.keys('myapp:*')
if keys:
    r.delete(*keys)
```

## Prefix Isolation

Different prefixes are completely isolated:

```python
os.environ['REDIS_PREFIX'] = 'app1:'
mem1 = Memory()
mem1.shared = "app1 value"

os.environ['REDIS_PREFIX'] = 'app2:'
mem2 = Memory()
print(hasattr(mem2, 'shared'))  # False - different namespace
```
