# Changelog

All notable changes to this project will be documented in this file.

## [0.2.1] - 2025-05-15

### Added
- Enhanced `format_money/3` to support `Decimal` and properly parse binary strings representing decimals.
- Added error handling to `format_money/3` for invalid or malformed binary string inputs, raising `ArgumentError`.
- Added unit tests covering valid and invalid binary string inputs for `format_money/3`.

## [0.2.0] - 2025-05-14

### Added
- `to_date/3` to parse dates with an optional fallback or custom parsing logic.

## [0.1.2] - 2025-05-11

### Added
- `format_money/3` to format monetary amounts using `Money.to_string/2` with optional formatting options.

## [0.1.1] - 2025-05-09

### Added
- `format_decimal/1` to format decimals with commas and 2 decimal places.
- `format_name/1` and `format_name/2` for flexible user name formatting.
- `format_name_with_email/1` for full name + email formatting.

## [0.1.0] - 2025-05-06

### Added
- Initial release with Changeset Helpers,  FormHelpers, and other utility functions.
