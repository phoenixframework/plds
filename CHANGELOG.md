# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.2] - 2021-10-06

### Changed

- Disable Metrics and Request Logger pages. See [#4](https://github.com/phoenixframework/plds/issues/4). 

## [0.1.1] - 2021-09-24

### Fixed

- Validate short and long names properly. This also add better defaults depending
on which type of nodes PLDS is connecting to.

### Changed

- The `--cookie` flag is now optional. By default it will use the one from
`Node.get_cookie()` when distribution is enabled.

## [0.1.0] - 2021-09-22

### Added

- Initial release of PLDS.

[Unreleased]: https://github.com/phoenixframework/plds/compare/v0.1.2...HEAD
[0.1.2]: https://github.com/phoenixframework/plds/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/phoenixframework/plds/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/phoenixframework/plds/releases/tag/v0.1.0
