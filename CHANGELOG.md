# Changelog

All notable changes to this project will be documented in this file.

## [0.3.1] - 2026-07-18

### Updated
- Expanded every public helper's documentation with practical use cases and expected results.
- Added README examples for changeset normalization, form options, date parsing, and value formatting.
- Added doctest coverage for general, date, and form helper examples.
- Corrected decimal formatting and changeset constraint examples to match supported behavior.

## [0.3.0] - 2026-07-18

### Added
- Added `normalize_strings/3` for trimming changeset string fields and converting blank values to `nil`.
- Added `validate_any_required/3` for requiring at least one of several changeset fields.
- Added configurable field and function selectors to `options_for/3` for form labels and values.

### Updated
- Updated Ecto to 3.14, Decimal to 3.1, ExDoc to 0.40, ex_cldr to 2.47, ex_cldr_numbers to 2.38, and ex_money to 6.1.
- Made `ex_cldr_numbers` a direct dependency because `number_to_words/1` uses it directly.
- Updated decimal formatting to reuse the existing CLDR backend.
- Updated the package version and installation documentation for the 0.3.0 release.

### Removed
- Removed the redundant and Decimal 3-incompatible `number` dependency and its stale lockfile entry.
- Removed the obsolete Money CLDR provider configuration.

### Fixed
- Disabled automatic ex_money exchange-rate service startup to avoid library startup side effects.
- Fixed the unclosed installation code block in the README.

## [0.2.6] - 2025-11-19
### Update
- Bump dependencies

## [0.2.5] - 2025-07-23
### Update
- Bump dependencies

## [0.2.4] - 2025-06-24
### Fixed
- Prevented `trim_whitespace/3` from raising `FunctionClauseError` when given non-string values.

### Added
- Test cases covering `nil`, integers, and booleans to validate `trim_whitespace/3` behavior with non-string types.

## [0.2.3] - 2025-06-05
### Refactor
- trim_whitespace/3 – Trims spaces in changeset fields and adds unique_constraint + max length validation.

## [0.2.2] - 2025-05-15
### Added
- trim_whitespace/3 – Trims spaces in changeset fields and adds unique_constraint + max length validation.
- number_to_words/1 – Converts a number into its word form.
- trim_description/2 – Truncates a string with ellipsis.

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
