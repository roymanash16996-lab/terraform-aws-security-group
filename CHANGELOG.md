# Release Notes
#
## Version 0.0.4 (2025-09-14)
### Previous Logic
- Resource selection in `locals.tf` relied on multiple flags (`use_name_prefix`, `create_before_destroy`, and user input), resulting in complex and sometimes ambiguous logic for choosing the correct security group resource and outputs.
- Deprecated resource variants (e.g., `this-name-prefix-dbc`, `this-name-prefix-cbd`) were referenced in locals and comments, increasing confusion and maintenance overhead.
- Comments and documentation were inconsistent across files, making onboarding and troubleshooting more difficult.
- Data source creation logic in `network.conf.tf` was less explicit, with limited validation and error handling for VPC selection.
- Output logic in `outputs.tf` did not consistently use null-safe patterns, risking errors when referencing outputs for external security groups.

### Current Logic (v0.0.4)
- `locals.tf` logic is now fully centralized and simplified:
  - Resource selection depends only on `create_before_destroy` and user input (`security_group_id`), removing all legacy resource variants.
  - The correct security group ID and object are selected using clear coalesce logic, ensuring rules and outputs always reference the intended resource.
  - Comments are expanded to explain the rationale, conditional logic, and use cases for each local value, supporting maintainability and onboarding.
- `main.tf` and `network.conf.tf` updated for clarity and reliability:
  - Resource creation logic now matches the simplified locals, with explicit conditions for each resource and data source.
  - Data source creation for VPC and region selection uses clear variable dependencies and count logic, with improved error handling and validation (e.g., aborting if multiple VPCs match a name).
  - All comments now follow a unified documentation standard, making the codebase easier to understand and maintain.
- `outputs.tf` logic improved:
  - Outputs consistently reference locals, using `try` for null safety to avoid errors when using external security groups.
  - Output documentation clarifies when values are null and how to use them downstream.

### Advantages of Current Logic
- **Simplicity & Maintainability:**
  - Centralized logic in `locals.tf` reduces duplication and ambiguity, making future updates and troubleshooting easier.
  - Removal of deprecated resource variants and legacy flags streamlines the codebase and documentation.
- **Reliability & Predictability:**
  - Explicit resource selection and output logic ensure that only the intended resources are created and referenced, reducing risk of drift and errors.
  - Improved validation and error handling in data source creation prevent ambiguous VPC selection and guide users to correct configuration.
- **Onboarding & Collaboration:**
  - Unified comments and documentation across all Terraform files make it easier for new users and collaborators to understand the module's logic and usage.
  - Clear rationale and use case explanations support best practices and compliance.
- **Extensibility:**
  - The simplified logic and documentation provide a strong foundation for future enhancements, such as supporting additional resource types or advanced conditional logic.
- **Null Safety & Integration:**
  - Consistent use of null-safe patterns in outputs ensures robust integration with other modules and prevents runtime errors.

### Fixed
- Patch context errors and reliability issues addressed in codebase (excluding README.md)
- Improved code comments and documentation in all Terraform files for clarity and maintainability

### Notes
- This release supersedes v0.0.3 and reflects all recent logic, maintainability, and documentation improvements in the Terraform codebase
- Please update the commit hash in the example usage to reference the correct version
#
## Version 0.0.3 (2025-09-13)
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

# Release Notes

## Version 0.0.2 (2025-09-12)
### Previous Logic & Issues
- **Previous Logic:**
  - Resource creation conditions were not fully documented, leading to confusion about when each security group or rule resource would be created.
  - Selection of resource variants (`this-dbc`, `this-name-prefix-dbc`, etc.) was implicit and not clearly explained in documentation.
  - Rule resources were created without explicit checks for empty lists or missing security group IDs, which could result in errors or unused resources.
  - Data source usage for region, VPC, and caller identity was not clearly described, making it harder to understand tagging and network selection.
  - Output references did not always clarify whether they referred to created or existing security groups.

+- **Issues (Broader Impact):**
  - **User Experience:** Users struggled to understand and control resource creation, leading to confusion and wasted time during deployment and troubleshooting.
  - **Documentation Gaps:** Incomplete or mismatched documentation made onboarding new users and maintaining the module more difficult, increasing the risk of misconfiguration and support requests.
  - **Reliability & Predictability:** Lack of explicit logic and validation increased the risk of resource drift, unexpected errors, and inconsistent infrastructure states, especially in complex or automated environments.
  - **Maintainability:** Implicit logic and unclear resource selection made future updates and refactoring harder, slowing down development and increasing technical debt.

- **Resolution in v0.0.2:**
  - All resource creation logic is now explicitly documented and validated.
  - Selection logic for resource variants is described in both code comments and README.md.
  - Rule creation uses explicit checks and for_each, preventing creation of unused resources.
  - Data source usage and output logic are clarified for transparency and maintainability.


### Logic Changes
- Resource creation logic is now fully documented and clarified:
  - Security group resources are created only if `security_group_id` is not provided and `create_security_group` is true.
  - The specific resource variant (`this-dbc`, `this-name-prefix-dbc`, `this-cbd`, `this-name-prefix-cbd`) is selected based on `use_name_prefix` and `create_before_destroy` variables.
  - Security group rule resources use `for_each` and are only created when the corresponding rules list is non-empty and a security group ID is available.
  - Data source usage for AWS caller identity, region, and VPC selection is clarified and documented.
  - Output logic is updated to reflect the correct references for created or existing security groups.

### Enhancements
- Updated README.md:
  - Moved Example Usage section before Resources, Variables, and Outputs.
  - Example now uses GitHub repository URL with commit hash reference.
  - Table of Contents updated to match new section order and titles.
  - Improved documentation for resource creation logic and variable/output tables.
- Improved code documentation in all Terraform files to match latest logic and use cases.
- Clarified resource creation conditions and data source usage in documentation.

### Bug Fixes
- Fixed Table of Contents links to match actual section headings.
- Resolved patching and formatting issues in README.md tables.

### Notes
- This release supersedes v0.0.1 and reflects all recent documentation and logic changes.
- Please update the commit hash in the example usage to reference the correct version.

---

## Version 0.0.1 (2025-09-12)

### Initial Release

This release introduces the AWS Security Group Terraform module with the following features:

#### Features
  - Supports creation of security groups with either a fixed name or a name prefix.
  - Lifecycle management with `create_before_destroy` for zero-downtime replacements.
  - Option to use an existing security group by providing its ID.

  - Ingress and egress rules are defined as lists of objects, supporting all major AWS rule types.
  - Each rule supports IPv4, IPv6, prefix list, or referenced security group (mutually exclusive).

  - All resources and rules are tagged with:
    - `CreatedBy`: AWS caller identity ARN
    - `Owner`: AWS account ID
    - `CreatedAt`: Timestamp
    - `Name`: Security group name
    - Custom tags from input

  - Supports deployment into any VPC or region, with automatic selection if not specified.

  - Exposes security group ID, ARN, and name for downstream use.

  - Terraform >= 1.5.7
  - AWS Provider >= 6.12.0

#### Files

#### Author


For usage instructions and more details, see the README.md in this folder.