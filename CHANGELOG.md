# Changelog

## v0.0.2 – September 12, 2025

### Added
- Example Usage section moved before Resources, Variables, and Outputs in README.md.
- Example now references GitHub repository URL with commit hash.
- Table of Contents updated to match new section order and titles.
- New section in release notes highlighting previous logic, issues, and resolutions.

### Changed
- Resource creation logic is now fully documented and clarified:
  - Security group resources are created only if `security_group_id` is not provided and `create_security_group` is true.
  - Resource variant selection (`this-dbc`, `this-name-prefix-dbc`, etc.) is now explicit and documented.
  - Security group rule resources use `for_each` and are only created when the rules list is non-empty and a security group ID is available.
  - Data source usage for AWS caller identity, region, and VPC selection is clarified.
  - Output logic updated to reflect correct references for created or existing security groups.
- Improved code documentation in all Terraform files to match latest logic and use cases.

### Fixed
- Table of Contents links now match actual section headings.
- Resolved patching and formatting issues in README.md tables.

### Notes
- This release supersedes v0.0.1 and reflects all recent documentation and logic changes.
- Please update the commit hash in the example usage to reference the correct version.
