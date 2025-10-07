# Changelog

<!-- markdownlint-disable MD024 -->

All notable changes to the Specify CLI will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [LATEST_VERSION] - RELEASE_DATE

### Added

- **Major UX Design Enhancement**: Complete integration of user experience design into the Spec-Driven Development workflow
- **New UX-Specific Commands**:
  - `/clarify-ux`: Deep clarification of UX design requirements with focus areas (research, interaction, visual, accessibility)
  - `/validate-ux`: Specialized validation for UX design completeness and quality
- **Enhanced Specification Template** (`templates/spec-template.md`):
  - Comprehensive "用户体验设计 (UX Design)" section with 7 core UX areas
  - User research insights, information architecture, interaction design, visual design requirements
  - Micro-interactions, animations, and usability testing requirements
  - Enhanced requirements checklist with UX design depth verification
- **New UX Design Template** (`templates/ux-design-template.md`):
  - Complete UX design documentation framework
  - User research, journey mapping, interaction flows, visual design systems
  - Accessibility compliance, responsive design, and usability testing plans
- **Enhanced Plan Template** (`templates/plan-template.md`):
  - New "1.1 UX 设计设计" phase with 5 UX design deliverables
  - Parallel UX design and technical design workflow
  - UX-specific task generation strategy
- **Enhanced Tasks Template** (`templates/tasks-template.md`):
  - New "阶段3.2：UX 设计实施" with 9 specific UX development tasks
  - UX testing tasks (UI components, end-to-end, accessibility, responsive)
  - Enhanced task generation rules for UX deliverables
- **New Validation Scripts**:
  - `validate-specification.sh/.ps1`: Cross-platform specification validation with scope-based checking
  - `clarify-ux-requirements.sh/.ps1`: UX-specific requirement clarification with focus areas
- **Requirements Traceability Template** (`templates/traceability-template.md`):
  - Complete traceability matrix from business requirements to test cases
  - Quality metrics and change tracking capabilities
- **Updated Documentation**:
  - `docs/ux-design-guide.md`: Comprehensive UX design guide for Spec Kit
  - Enhanced CLAUDE.md, README.md, and AGENTS.md with UX features
- **Support for using `.` as a shorthand for current directory in `specify init .` command, equivalent to `--here` flag but more intuitive for users

### Changed

- **Enhanced Constitution Template**: Added comprehensive demand review principles and quality gates
- **Improved Task Generation**: Now includes UX design tasks alongside technical implementation tasks
- **Extended CLI Help**: Updated help text to include new UX-specific commands and workflows

### Fixed

- Better handling of requirement simplification issues through comprehensive UX validation
- Improved requirement gap identification with specialized UX focus areas

## [0.0.17] - 2025-09-22

### Added

- New `/clarify` command template to surface up to 5 targeted clarification questions for an existing spec and persist answers into a Clarifications section in the spec.
- New `/analyze` command template providing a non-destructive cross-artifact discrepancy and alignment report (spec, clarifications, plan, tasks, constitution) inserted after `/tasks` and before `/implement`.
	- Note: Constitution rules are explicitly treated as non-negotiable; any conflict is a CRITICAL finding requiring artifact remediation, not weakening of principles.

## [0.0.16] - 2025-09-22

### Added

- `--force` flag for `init` command to bypass confirmation when using `--here` in a non-empty directory and proceed with merging/overwriting files.

## [0.0.15] - 2025-09-21

### Added

- Support for Roo Code.

## [0.0.14] - 2025-09-21

### Changed

- Error messages are now shown consistently.

## [0.0.13] - 2025-09-21

### Added

- Support for Kilo Code. Thank you [@shahrukhkhan489](https://github.com/shahrukhkhan489) with [#394](https://github.com/github/spec-kit/pull/394).
- Support for Auggie CLI. Thank you [@hungthai1401](https://github.com/hungthai1401) with [#137](https://github.com/github/spec-kit/pull/137).
- Agent folder security notice displayed after project provisioning completion, warning users that some agents may store credentials or auth tokens in their agent folders and recommending adding relevant folders to `.gitignore` to prevent accidental credential leakage.

### Changed

- Warning displayed to ensure that folks are aware that they might need to add their agent folder to `.gitignore`.
- Cleaned up the `check` command output.

## [0.0.12] - 2025-09-21

### Changed

- Added additional context for OpenAI Codex users - they need to set an additional environment variable, as described in [#417](https://github.com/github/spec-kit/issues/417).

## [0.0.11] - 2025-09-20

### Added

- Codex CLI support (thank you [@honjo-hiroaki-gtt](https://github.com/honjo-hiroaki-gtt) for the contribution in [#14](https://github.com/github/spec-kit/pull/14))
- Codex-aware context update tooling (Bash and PowerShell) so feature plans refresh `AGENTS.md` alongside existing assistants without manual edits.

## [0.0.10] - 2025-09-20

### Fixed

- Addressed [#378](https://github.com/github/spec-kit/issues/378) where a GitHub token may be attached to the request when it was empty.

## [0.0.9] - 2025-09-19

### Changed

- Improved agent selector UI with cyan highlighting for agent keys and gray parentheses for full names

## [0.0.8] - 2025-09-19

### Added

- Windsurf IDE support as additional AI assistant option (thank you [@raedkit](https://github.com/raedkit) for the work in [#151](https://github.com/github/spec-kit/pull/151))
- GitHub token support for API requests to handle corporate environments and rate limiting (contributed by [@zryfish](https://github.com/@zryfish) in [#243](https://github.com/github/spec-kit/pull/243))

### Changed

- Updated README with Windsurf examples and GitHub token usage
- Enhanced release workflow to include Windsurf templates

## [0.0.7] - 2025-09-18

### Changed

- Updated command instructions in the CLI.
- Cleaned up the code to not render agent-specific information when it's generic.


## [0.0.6] - 2025-09-17

### Added

- opencode support as additional AI assistant option

## [0.0.5] - 2025-09-17

### Added

- Qwen Code support as additional AI assistant option

## [0.0.4] - 2025-09-14

### Added

- SOCKS proxy support for corporate environments via `httpx[socks]` dependency

### Fixed

N/A

### Changed

N/A
