# Release Notes

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