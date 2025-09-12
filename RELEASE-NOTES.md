# Release Notes

## Version 0.0.1 (2025-09-12)

### Initial Release

This release introduces the AWS Security Group Terraform module with the following features:

#### Features
- **Flexible Security Group Creation**
  - Supports creation of security groups with either a fixed name or a name prefix.
  - Lifecycle management with `create_before_destroy` for zero-downtime replacements.
  - Option to use an existing security group by providing its ID.

- **Dynamic Rule Management**
  - Ingress and egress rules are defined as lists of objects, supporting all major AWS rule types.
  - Each rule supports IPv4, IPv6, prefix list, or referenced security group (mutually exclusive).

- **Tagging and Traceability**
  - All resources and rules are tagged with:
    - `CreatedBy`: AWS caller identity ARN
    - `Owner`: AWS account ID
    - `CreatedAt`: Timestamp
    - `Name`: Security group name
    - Custom tags from input

- **Network and Region Selection**
  - Supports deployment into any VPC or region, with automatic selection if not specified.

- **Outputs**
  - Exposes security group ID, ARN, and name for downstream use.

- **Provider and Terraform Version Requirements**
  - Terraform >= 1.5.7
  - AWS Provider >= 6.12.0

#### Files
- `main.tf`: Core resources and logic
- `variables.tf`: Input variable definitions
- `locals.tf`: Local values for resource selection and logic
- `network.conf.tf`: Data sources for region and VPC
- `outputs.tf`: Output values
- `versions.tf`: Version constraints

#### Author
- Created by: Manash Roy

---

For usage instructions and more details, see the README.md in this folder.