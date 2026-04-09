# Changelog

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
