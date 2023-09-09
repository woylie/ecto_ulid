# Ecto.ULID Next

[![Elixir CI](https://github.com/woylie/ecto_ulid/actions/workflows/elixir.yml/badge.svg)](https://github.com/woylie/ecto_ulid/actions/workflows/elixir.yml)
[![Hex](https://img.shields.io/hexpm/v/ecto_ulid_next)](https://hex.pm/packages/ecto_ulid_next)

Ecto.ULID Next is an `Ecto.Type` implementation for [ULID](https://github.com/ulid/spec).

Originally forked from [TheRealReal/ecto-ulid](https://github.com/TheRealReal/ecto-ulid),
this library is actively maintained to ensure compatibility with both current
and upcoming Ecto releases.

## Features

- Generate ULIDs in either Base32 or binary format.
- Generate ULIDs based on a specific timestamp.
- Autogenerate ULIDs when used as a primary key in your schema.
- Read and write ULIDs using the database's native `uuid` type—no need for
  additional database extensions.
- Supports Ecto 3.2 and above.
- Supports the [officially supported Elixir versions](https://hexdocs.pm/elixir/compatibility-and-deprecations.html) (currently ~> 1.11).
- Tested and confirmed to work on both PostgreSQL and MySQL.
- Optimized for high throughput scenarios.

## Why Choose ULID?

ULID (Universally Unique Lexicographically Sortable Identifier) offers
lexicographic sorting, unlike UUID. This feature simplifies chronological
sorting and range queries, making ULID advantageous for time-series data, event
sourcing, and other specific use-cases.

Note: UUID v7 is a new proposed format that also aims to offer lexicographic
sorting.

## Compatibility Considerations

ULID is binary-compatible with UUID, which means `Ecto.ULID` can be used
interchangeably in environments where `Ecto.UUID` is supported. It has been
confirmed to work with PostgreSQL and MySQL with the `uuid` column type.

## Performance

`Ecto.ULID` is optimized for quick operations, particularly useful in scenarios
requiring the handling of a large volume of events. The library borrows
techniques from `Ecto.UUID` to achieve sub-microsecond times for most
operations.

A benchmark suite is included to test the performance. Clone the repository and
run `mix run bench/ulid_bench.exs` to gauge how the library performs on your own
system.

## Installation

To install `ecto_ulid_next`, add it to your project's dependencies in `mix.exs`:

```elixir
defp deps do
  [
    {:ecto_ulid_next, "~> 1.0.1"}
  ]
end
```

## Usage Scenarios

The following sections outline three practical examples of how to use
`Ecto.ULID`. For API details, refer to the
[documentation](https://hexdocs.pm/ecto_ulid_next).

### Using `Ecto.ULID` as a Primary Key or Foreign Key for a Single Table

#### Migration

In your migration file, specify `:binary_id` as the column type for the
primary key and any foreign keys.

```elixir
create table(:events, primary_key: false) do
  add :id, :binary_id, primary_key: true
  add :user_id, references(:users, type: :binary_id)
  # additional fields
end
```

#### Schema Definition

In your schema, set both `@primary_key` and `@foreign_key_type` to `Ecto.ULID`.
This will default both the primary key and all foreign keys in the schema to use
the ULID type.

```elixir
defmodule MyApp.Event do
  use Ecto.Schema

  @primary_key {:id, Ecto.ULID, autogenerate: true}
  @foreign_key_type Ecto.ULID

  schema "events" do
    belongs_to :user, MyApp.User
    # additional fields
  end
end
```

To specify the ULID type for an individual association within the current
schema, you can set the `type` option in the `belongs_to` function:

```elixir
defmodule MyApp.Event do
  use Ecto.Schema

  @primary_key {:id, Ecto.ULID, autogenerate: true}

  schema "events" do
    belongs_to :user, MyApp.User, type: Ecto.ULID
    # additional fields
  end
end
```

### Using `Ecto.ULID` as Primary Keys Across Multiple Tables

#### Global Migration Configuration

First, set a global configuration for all migrations to use `:binary_id` as the
primary key type in `config/config.exs`.

```elixir
config :my_app, MyApp.Repo,
  migration_primary_key: [name: :id, type: :binary_id],
  migration_foreign_key: [type: :binary_id]
```

With this configuration, there's no need to explicitly define the primary key
column and the foreign key column type.

```elixir
create table(:events) do
  belongs_to :user, MyApp.User
  # additional fields
end
```

#### Shared Schema Configuration

Create a shared module to house general schema configurations. This module will
set `Ecto.ULID` as the default for both primary and foreign keys.

```elixir
defmodule MyApp.Schema do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      use Ecto.Schema

      @primary_key {:id, Ecto.ULID, autogenerate: true}
      @foreign_key_type Ecto.ULID
    end
  end
end
```

When defining individual schemas, simply use `MyApp.Schema` instead of
`Ecto.Schema`. This eliminates the need to specify these attributes in each
schema.

```elixir
defmodule MyApp.Event do
  use MyApp.Schema

  schema "events" do
    # additional fields
  end
end
```

### Manual ULID Generation

#### Using the Current System Time

Use `Ecto.ULID.generate/0` or `Ecto.ULID.bingenerate/0` to create ULIDs in
string or binary format based on the current system time. This is useful for
sending ULIDs to external systems or for use with `c:Ecto.Repo.insert_all/3`,
where autogenerated fields are not set automatically.

```elixir
iex> Ecto.ULID.generate()
"01BZ13RV29T5S8HV45EDNC748P"

iex> Ecto.ULID.bingenerate()
<<1, 95, 194, 60, 108, 73, 209, 114, 136, 236, 133, 115, 106, 195, 145, 22>>
```

#### Specifying a Timestamp

To generate a ULID based on a specific timestamp—useful for backfilling
historical data—you can use `Ecto.ULID.generate/1` or `Ecto.ULID.bingenerate/1`.

```elixir
iex> Ecto.ULID.generate(1402899630000)
"018THNB1XGQZ7T929PD126SM3Z"

iex> Ecto.ULID.bingenerate(1402899630000)
<<1, 70, 163, 85, 135, 176, 12, 219, 112, 32, 157, 209, 98, 152, 55, 37>>
```

## Further Reading

### Specifications

- [ULID specification](https://github.com/ulid/spec)
- [UUID v7 specification](https://datatracker.ietf.org/doc/html/draft-ietf-uuidrev-rfc4122bis#name-uuid-version-7)

### Database Support and Tools

ULIDs are not natively supported by most databases, which means querying data
directly may display IDs in UUID format rather than the Crockford Base32
representation. For PostgreSQL, the following tool can help convert between ULID
and UUID formats:

- [pgsql-ulid](https://github.com/scoville/pgsql-ulid)

### Articles and Insights

- [Understanding UUIDs, ULIDs and String Representations](https://sudhir.io/uuids-ulids)
