# Changelog

## Unreleased

### Changed

- Minor dependency and documentation updates.

## [0.3.1] - 2022-02-22

Maintenance release

### Changed

- Elixir version support now follows the
  [officially supported Elixir versions](https://hexdocs.pm/elixir/1.13/compatibility-and-deprecations.html).
- Update test matrix accordingly.
- Improve documentation and type specs.

## [0.3.0] - 2020-11-16

### Changed

- Minimum supported Ecto is now 3.2.
- Minimum supported Elixir is now 1.7.

## [0.2.0] - 2019-01-17

### Changed

- Minimum supported Elixir is now 1.4.
- ([#3](https://github.com/TheRealReal/ecto-ulid/pull/3))
  Fix deprecation warnings regarding time units.

## [0.1.1] - 2018-12-03

### Added

- ([#2](https://github.com/TheRealReal/ecto-ulid/pull/2))
  Add support for Ecto 3.x.

## [0.1.0] - 2018-06-06

### Added

- Generate ULID in Base32 or binary format.
- Generate ULID for a given timestamp.
- Autogenerate ULID when used as a primary key.
- Supports reading and writing ULID in a database backed by its native `uuid` type (no database
  extensions required).
- Supports Ecto 2.x.
- Supports Elixir 1.2 and newer.
- Tested with PostgreSQL and MySQL.
