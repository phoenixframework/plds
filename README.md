# PLDS - Phoenix LiveDashboard Standalone

[![CI](https://github.com/phoenixframework/plds/actions/workflows/ci.yml/badge.svg)](https://github.com/phoenixframework/plds/actions/workflows/ci.yml)

<!-- MDOC !-->

PLDS is a command line interface for [Phoenix LiveDashboard](https://github.com/phoenixframework/phoenix_live_dashboard)
with some additional extensions.

It's useful in environments where you can't install Phoenix or the dashboard.
This can be used to access remote systems that are reachable locally.

## Usage

You can install PLDS by running the following command:

    $ mix escript.install hex plds

Make sure the path used for installing escripts is available in your
[$PATH](https://en.wikipedia.org/wiki/PATH_(variable)) variable.
If you installed Elixir with `asdf`, you'll need to run `asdf reshim elixir`
once the escript is built.

After that, you can start PLDS with the following command:

    $ plds server --connect node_a --connect node_b --port 9000 --open

The dashboard will open a page in your browser.
Check the options available by typing `plds server --help`.
Note that the PLDS node will be hidden from the other nodes.

To try out features from the main branch you can alternatively
install the escript directly from GitHub like this:

    $ mix escript.install github phoenixframework/plds

### Environment variables

PLDS accepts some configuration through environment variables.
The only one available today is:

* `PDLS_SECRET_KEY_BASE` - the secret base used for session encryption. It must
  be at least 64 characters long. You can use OpenSSL or the [`:crypto.strong_rand_bytes/1`](https://erlang.org/doc/man/crypto.html#strong_rand_bytes-1) function to generate it.
  `openssl rand -base64 48` if you have OpenSSL available.
  By default it's a random value.

## Preinstalled tools

- Ecto with extras - works for PostgreSQL databases.
- Broadway Dashboard - to inspect Broadway pipelines.

<!-- MDOC !-->

## Development

PLDS is primarily a Phoenix web application and can be setup as such:

```shell
git clone https://github.com/phoenixframework/plds.git
cd plds
mix deps.get

# Run the PLDS server
mix phx.server

# To test escript
MIX_ENV=prod mix escript.build
./plds server
```

## License

MIT License. Copyright (c) 2021 Philip Sampaio.
