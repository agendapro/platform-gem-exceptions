# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

`platform-gem-exceptions` is a Ruby gem that provides standardized exception handling for Rails controller actions. It is used across AgendaPro's platform services to ensure consistent JSON error responses and New Relic error reporting.

**This is a public repo — no credentials or internal information.**

## Commands

- **Run all tests + lint:** `bundle exec rake` (default task runs both spec and rubocop)
- **Run tests only:** `bundle exec rspec`
- **Run a single test file:** `bundle exec rspec spec/platform/exception_handlers/failure_spec.rb`
- **Run a single test by line:** `bundle exec rspec spec/platform/exception_handlers/failure_spec.rb:10`
- **Lint:** `bundle exec rubocop`
- **Lint with auto-fix:** `bundle exec rubocop -A`

## Architecture

### Core: `Platform::ExceptionHandler` (ActiveSupport::Concern)

Included in Rails controllers via `include Platform::ExceptionHandler`. Registers `rescue_from` handlers that catch exceptions, delegate to a handler class, then render a JSON response with the appropriate HTTP status.

### Exception Handlers (`lib/platform/exception_handlers/`)

Each handler class follows the same interface — `initialize(exception)`, `body`, `status`, `log`:

| Handler | Exception | HTTP Status | Error Key |
|---|---|---|---|
| `StandardError` | `::StandardError` | `:internal_server_error` | `internal_error` |
| `Failure` | `ServiceActor::Failure` | dynamic from `result[:status]` or `:unprocessable_content` | dynamic from `result[:error]` |
| `ArgumentError` | `ServiceActor::ArgumentError` | `:bad_request` | parsed from `ErrorMessage` JSON |
| `RecordInvalid` | `ActiveRecord::RecordInvalid` | `:bad_request` | `invalid_format` |
| `RecordNotFound` | `ActiveRecord::RecordNotFound` | `:not_found` | `not_found` |

All handlers report to New Relic via `Platform::NewRelicError` (a `SimpleDelegator` that customizes the error message while preserving the original exception class).

### ServiceActor Check Overrides (`lib/service_actor/checks/`)

Monkey-patches `DEFAULT_MESSAGE` on `ServiceActor::Checks::{NilCheck,TypeCheck,InclusionCheck}` to produce `Platform::ErrorMessage` JSON instead of plain strings. This ensures actor validation failures flow through the same error format.

### `Platform::ErrorMessage`

Value object with `error` and `detail` fields. Serializable to/from JSON. Used as the standard error payload format.

## Testing

- Tests mock `Rails`, `NewRelic::Agent`, `ActiveRecord::RecordInvalid`, and `ActiveRecord::RecordNotFound` in `spec/spec_helper.rb` (the gem has no runtime Rails dependency for testing).
- SimpleCov enforces **100% line and branch coverage**.
- Ruby target: >= 3.2 (CI runs 3.4.8).
