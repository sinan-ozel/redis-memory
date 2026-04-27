# Changelog

## [0.4.2] - 2026-04-27

### Changed
- The circuit breaker introduced in 0.4.1 has been replaced with a
  background-thread-owned availability flag. The background thread is now
  the sole owner of the `_redis_available` flag and the only part of the
  code that ever attempts a Redis connection for writes.
- When Redis is available (`_redis_available = True`) reads and writes go
  directly to Redis, preserving immediate cross-instance consistency.
- When Redis is unavailable (`_redis_available = False`) the main thread
  skips connection attempts entirely: reads return the local cache and
  writes queue locally without blocking.
- The background thread retries with exponential backoff starting at 1 s,
  doubling on each consecutive failure up to a 30 s cap, and resetting to
  1 s after a successful flush.
- `_flush_queue` now attempts a single connection and raises on failure
  instead of looping indefinitely, making `stop_background_flush()` always
  return promptly.

### Fixed
- Deleting an attribute while Redis was available incorrectly wrote a
  `{"value": null}` sentinel to Redis via `SET`, causing subsequent reads
  to return `None` instead of raising `AttributeError`. Deletion now calls
  `client.delete()` directly; the `{"value": null}` sentinel is only used
  for deferred (queued) deletions when Redis is down.
- Reading an attribute whose write was queued but not yet flushed would
  raise `AttributeError` even though the value was held in the local cache.
  `__getattr__` now falls through to the local cache when Redis is up but
  the key is not yet present.

## [0.4.1] - 2026-04-09

### Changed
- Removed all logging. The library no longer emits any log output.

### Fixed
- Writes no longer block repeatedly when Redis is unavailable. A circuit breaker
  prevents repeated connection attempts: after the first failure, subsequent
  writes queue immediately until the retry interval passes, avoiding the
  0.5-second connection timeout on every write.

## [0.3.4] - unreleased

Internal version bump between 0.3.2 and 0.4.1.

## [0.3.2]

### Fixed
- Minor badge issue in README.

## [0.3.1]

### Added
- Support for mutating nested lists and dicts (mutations to `SyncedList` and
  `SyncedDict` propagate to Redis automatically).
- Badges added to README.

### Fixed
- CI/CD pipeline reliability improvements.

## [0.3.0]

### Added
- `.aslist()` and `.asdict()` methods on `SyncedList` and `SyncedDict` to
  return plain Python types, resolving serialization issues with external
  libraries (e.g. pickling, deepcopy).

## [0.2.1]

First stable release.
