# Ecto.ULID Next

[![Elixir CI](https://github.com/woylie/ecto_ulid/actions/workflows/elixir.yml/badge.svg)](https://github.com/woylie/ecto_ulid/actions/workflows/elixir.yml)
[![Hex](https://img.shields.io/hexpm/v/ecto_ulid_next)](https://hex.pm/packages/ecto_ulid_next)

An `Ecto.Type` implementation of [ULID](https://github.com/ulid/spec).

> This is a fork of [TheRealReal/ecto-ulid](https://github.com/TheRealReal/ecto-ulid),
> which doesn't seem to be maintained anymore. The aim is to ensure compatibility
> with current and future Ecto versions.

## Features

- Generate ULID in Base32 or binary format.
- Generate ULID for a given timestamp.
- Autogenerate ULID when used as a primary key.
- Supports reading and writing ULID in a database backed by its native `uuid`
  type (no database extensions required).
- Supports Ecto ~> 3.2.
- Supports the [officially supported Elixir versions](https://hexdocs.pm/elixir/compatibility-and-deprecations.html) (currently ~> 1.10).
- Confirmed working on PostgreSQL and MySQL.
- Optimized for high throughput.

## Why to use ULID?

ULID is the abbreviation for Universally Unique Lexicographically Sortable Identifier.

Just as its name suggests, **ULID supports lexicographically sorting**, which is
not supported by UUID.

## Compatibility

ULID is binary-compatible with UUID. Because of that, `Ecto.ULID` should be compatible
anywhere that `Ecto.UUID` is supported.

It has been confirmed to work with PostgreSQL and MySQL, with using `uuid` column in a
database.

## Performance

Since one use case of ULID is to handle a large volume of events, `Ecto.ULID` is
optimized to be as fast as possible. It borrows techniques from `Ecto.UUID` to
achieve sub-microsecond times for most operations.

A benchmark suite is included. Download the repository and run `mix run bench/ulid_bench.exs`
to test the performance on your system.

## Installation

Install `ecto_ulid_next` by adding it to the dependencies in
`mix.exs`:

```elixir
defp deps do
  [
    {:ecto_ulid_next, "~> 1.0.1"}
  ]
end
```

## Usage

Below are three common use cases, for more details please refer to the
[documentation](https://hexdocs.pm/ecto_ulid_next).

### case 1 - use `Ecto.ULID` as a primary key for one table

When adding a column in a migration, `:binary_id` is used as the type of that column:

> As said above, ULID is binary-compatible with UUID. Using `:binary_id` directly can
> reduce the hassle of customizing database data types.

```elixir
create table(:events, primary_key: false) do
  add :id, :binary_id, null: false, primary_key: true
  # ...
end
```

When defining a schema, use `Ecto.ULID` for the `@primary_key` or `@foreign_key_type`
as appropriate:

```elixir
defmodule MyApp.Event do
  use Ecto.Schema

  @primary_key {:id, Ecto.ULID, autogenerate: true}
  @foreign_key_type Ecto.ULID

  schema "events" do
    # ...
  end
end
```

### case 2 - use `Ecto.ULID` as primary keys for all tables

First, configure all the migrations to use `:binary_id` as primary keys:

```elixir
config :my_app, MyApp.Repo, migration_primary_key: [name: :id, type: :binary_id]
```

Then, just create migrations. There's no need to specify the `id` column:

```elixir
create table(:events) do
  # ...
end
```

Before defining schemas, create a shared module containing general configurations:

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

When defining a schema, just use `use MyApp.Schema`. There's no need to specify
other module attributes:

```elixir
defmodule MyApp.Event do
  use MyApp.Schema

  schema "events" do
    # ...
  end
end
```

## case 3 - generate a ULID directly

A ULID can be generated in string or binary format by calling `generate/0` or
`bingenerate/0`. This can be useful when generating ULIDs to send to external
systems:

```elixir
iex> Ecto.ULID.generate()
"01BZ13RV29T5S8HV45EDNC748P"

iex> Ecto.ULID.bingenerate()
<<1, 95, 194, 60, 108, 73, 209, 114, 136, 236, 133, 115, 106, 195, 145, 22>>
```

To backfill old data, it may be helpful to pass a timestamp to `generate/1` or
`bingenerate/1`.

## LICENSE

[MIT](./LICENSE)
