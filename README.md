# Multi-Environment Infrastructure with Terragrunt & Terraform

This repository demonstrates how to manage infrastructure across multiple environments using Terraform modules and Terragrunt, providing reusable, scalable, and maintainable infrastructure-as-code.

## Folder Structure

```
infra/
├── modules/                  # Reusable Terraform modules (VPC, EC2, RDS, etc.)
├── dev/
│   └── vpc/
│       └── terragrunt.hcl    # Dev environment Terragrunt config for VPC
├── staging/
│   └── vpc/
│       └── terragrunt.hcl    # Staging environment Terragrunt config for VPC
└── terragrunt.hcl            # Root Terragrunt config (common settings, remote state, provider, etc.)
```

### Explanation

- **modules/** – Terraform modules that define infrastructure components (VPC, EC2, RDS, etc.)
- **dev/**, **staging/** – Environment-specific Terragrunt configurations referencing modules
- **infra/terragrunt.hcl** – Root Terragrunt config for shared settings such as backend, provider, and common variables

## Prerequisites

Before running the project, ensure you have the following installed:

- **Terraform** – Install [Terraform](https://www.terraform.io/downloads.html) (v1.x recommended)
- **Terragrunt** – Install [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/) (v0.51.x or above)
- **AWS CLI** – Configured with credentials and default region (or the equivalent cloud provider CLI)
- Optional: **jq** or **yq** for processing variables (if used in modules or scripts)

## Installation & Setup

1. **Clone the repository**
    ```sh
    git clone <your-repo-url>
    cd infra
    ```

2. **Configure AWS CLI credentials**
    ```sh
    aws configure
    ```
    Make sure your IAM user/role has the required permissions for provisioning resources.

3. **Initialize Terragrunt**
    ```sh
    terragrunt init
    ```
    This will initialize Terraform modules and download any dependencies.

## Commands

### Plan Infrastructure

Plan infrastructure for a specific environment:

```sh
terragrunt plan --terragrunt-working-dir dev/vpc
```

or for staging:

```sh
terragrunt plan --terragrunt-working-dir staging/vpc
```

### Apply Infrastructure

Apply changes for a specific environment:

```sh
terragrunt apply --terragrunt-working-dir dev/vpc
```

Apply all environments at once:

```sh
terragrunt apply-all
```

> **Note:** `apply-all` will apply infrastructure changes across all environments under the current Terragrunt root configuration.

### Destroy Infrastructure

Destroy resources for a specific environment:

```sh
terragrunt destroy --terragrunt-working-dir dev/vpc
```

Destroy all environments:

```sh
terragrunt destroy-all
```

## Benefits

- **Environment Separation** – Clear separation between dev, staging, and prod environments
- **Reusable Modules** – Define infrastructure once, reuse across environments
- **DRY Infrastructure-as-Code** – Avoids duplication, reduces human errors
- **Centralized Management** – Remote state, provider configs, and common variables are centralized in the root Terragrunt file
- **One Command Deployment** – Apply infrastructure across multiple environments with a single command

## Contribution

Contributions are welcome! Feel free to:

- Open issues for suggestions or bugs
- Submit pull requests for improvements

## License

MIT License
