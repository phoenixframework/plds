# PLDS - Phoenix Live Dashboard Standalone

PLDS is a bundle of Phoenix Live Dashboard with some tools preinstalled.

It's useful in environments where you can't install Phoenix or the dashboard.
This can be used to access remote system that are available locally.

## Usage

You can install PLDS using the `mix escript.install hex plds` (or if it's not
published yet, `mix escript.install github phoenixframework/plds`).

Make sure the path used for installing escripts are available in your
`PATH` variable.

After that, you can start PLDS with the following command:

    $ plds server --open

The dashboard will open a page in your browser.
Check the options available by typing `plds --help`.

## Preinstalled tools

- Ecto with extras - works for PostgreSQL databases.
- Broadway Dashboard - to inspect Broadway pipelines.

## License

MIT License. Copyright (c) 2021 Michael Crumm, Chris McCord, José Valim.
