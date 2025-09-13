# Changelog


## v0.0.3 – September 13, 2025

### Added
- Comprehensive Usage section in README.md expanded to ~2500 words, including:
  - Detailed explanations for new and advanced users
  - Step-by-step getting started guide
  - Practical guidance, best practices, and troubleshooting tips
  - Real-world and advanced scenarios, integration examples, and security recommendations
- Variable table in README.md now includes a 'default value' column for all variables
- Additional documentation for module features, integration, and compliance use cases
- Logic changes in `network.conf.tf`:
  - Improved conditional creation of data sources for region and VPC selection
  - Enhanced logic for selecting default VPC, provided VPC by name, and handling VPC ID
  - Added validation resource to abort if multiple VPCs match the provided name, with user guidance
  - Updated comments and documentation to clarify dependencies and creation conditions for each data source

### Changed
- Table of Contents updated to include Usage section and reflect new section order
- Usage section now provides extensive onboarding and practical advice for Terraform Registry users
- Data Sources section in README.md clarified and corrected to match latest logic
- All documentation and code comments updated to reflect current resource creation logic, variable defaults, and output schemas
- `network.conf.tf` logic for VPC and region selection is now fully documented and clarified, including:
  - Data source creation conditions based on `vpc_name` and `vpc_id` variables
  - Improved handling of default and provided VPC selection
  - Explicit validation for multiple VPC matches
  - Updated comments to match new logic and dependencies

### Fixed
- Improved markdown table formatting and patch reliability in README.md
- Corrected and clarified Data Sources documentation for VPC and region selection logic
- Addressed minor formatting and link issues in documentation

### Notes
- This release supersedes v0.0.2 and includes all recent documentation, onboarding, and logic improvements
- Please update the commit hash in the example usage to reference the correct version
