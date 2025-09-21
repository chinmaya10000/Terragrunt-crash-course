# Terragrunt Infrastructure Deployment

This repository provides a Terraform/Terragrunt setup for deploying a robust 3-tier application environment—consisting of a VPC, Application Load Balancer (ALB), and Auto Scaling Group (ASG)—on AWS. The architecture supports multiple environments, such as `dev` and `staging`, and follows best practices for modularity, scalability, and maintainability.

## Folder Structure

```
infra/
├─ modules/
│  ├─ vpc/       # VPC, subnets, route tables, NAT gateways
│  ├─ alb/       # Application Load Balancer, listeners, target groups
│  └─ asg/       # Auto Scaling Group, launch templates, security groups
└─ live/
   ├─ dev/
   │  ├─ vpc/        # Terragrunt config for dev VPC
   │  ├─ alb/        # Terragrunt config for dev ALB
   │  └─ asg/        # Terragrunt config for dev ASG
   └─ staging/
      ├─ vpc/        # Terragrunt config for staging VPC
      ├─ alb/        # Terragrunt config for staging ALB
      └─ asg/        # Terragrunt config for staging ASG
```

## Module Dependency Diagram

```
      ┌──────────┐
      │   VPC    │
      │ (Network │
      │  Layer)  │
      └────┬─────┘
           │
           ▼
      ┌──────────┐
      │   ALB    │
      │(Load     │
      │Balancer) │
      └────┬─────┘
           │
           ▼
      ┌──────────┐
      │   ASG    │
      │(Compute  │
      │ Layer)   │
      └──────────┘
```

- **VPC Module**: Creates networking resources (VPC, public/private subnets, route tables, NAT gateway).
- **ALB Module**: Uses VPC outputs to deploy an Application Load Balancer with listeners and target groups.
- **ASG Module**: Uses VPC and ALB outputs to deploy EC2 instances in private subnets behind the ALB.

## Root Terragrunt Configuration

The root Terragrunt configuration defines:

- **AWS Provider Configuration**
- **Remote State Backend Configuration:** (S3/DynamoDB recommended, or local for testing)

All environment module configs include the root config to inherit provider and backend settings.

## Module-Level Terragrunt Configuration

Each environment module folder contains a Terragrunt configuration that:

- Points to the Terraform module source
- Passes environment-specific input values
- Uses dependencies for outputs from other modules if required

This ensures each module can be deployed independently or in the correct dependency order.

## Getting Started

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html)
- [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/)

### Installing Terragrunt

**macOS/Linux (Homebrew):**
```sh
brew install terragrunt
```

**macOS/Linux (curl):**
```sh
curl -L https://github.com/gruntwork-io/terragrunt/releases/latest/download/terragrunt_linux_amd64 -o /usr/local/bin/terragrunt
chmod +x /usr/local/bin/terragrunt
```

**Windows:**

Download the binary from the [Terragrunt releases page](https://github.com/gruntwork-io/terragrunt/releases).

Verify installation:
```sh
terragrunt --version
```

## Deploying the Infrastructure

1. **Navigate** to the desired environment folder (e.g., `infra/live/dev`).
2. **Initialize** Terragrunt:
   ```sh
   terragrunt init
   ```
3. **Apply individual modules in order** (VPC → ALB → ASG):
   ```sh
   cd vpc && terragrunt apply
   cd ../alb && terragrunt apply
   cd ../asg && terragrunt apply
   ```
   Or **deploy all modules automatically** in dependency order:
   ```sh
   terragrunt run-all apply
   ```

## Environment Differences

- **Dev:** Smaller CIDR blocks, fewer availability zones, smaller instance types.
- **Staging:** Larger CIDR blocks, more availability zones, potentially larger instance types.

All environment-specific values are defined in each module’s Terragrunt configuration.

## Module Outputs

Each module exposes outputs for consumption by other modules or for reference:

- **VPC:** VPC ID, public subnet IDs, private subnet IDs
- **ALB:** ALB DNS name, security group ID, target group ARNs
- **ASG:** Auto Scaling Group name, launch template ID, security group ID

## Best Practices

- Use **remote state** for collaboration (S3 + DynamoDB recommended)
- Keep environment-specific inputs in module-level Terragrunt configurations
- Use **dependencies** to automatically fetch outputs from other modules
- Avoid hardcoding shared values; use **locals** if multiple modules share the same values

## References

- [Terragrunt Documentation](https://terragrunt.gruntwork.io/docs/)
- [Terraform Modules Best Practices](https://www.terraform.io/docs/language/modules/index.html)

---

**Contributions welcome!** Please open issues or pull requests for improvements or questions.