# Highly Available 3-Tier Architecture on AWS using Terraform

## Overview

This project provisions a production-grade, highly available 3-tier web architecture on AWS using Terraform. The infrastructure is fully modularized, separating networking, security, compute, and database components to follow Infrastructure as Code (IaC) best practices.

## Architecture Diagram
![Highly Available 3-Tier AWS Architecture](Highly Available 3-Tier AWS Architecture.drawio (1).png)

## Technology Stack

- **Cloud Provider:** AWS
- **Infrastructure as Code:** Terraform
- **Networking:** VPC, Public/Private Subnets, Internet Gateway, NAT Gateway, Route Tables
- **Compute:** EC2, Auto Scaling Groups (ASG), Launch Templates
- **Load Balancing:** Application Load Balancer (ALB)
- **Database:** Amazon RDS (Multi-AZ)
- **State Management:** S3 (State File)

## Key Features

- **High Availability:** Application and database tiers are deployed across multiple Availability Zones.
- **Security Group Chaining:** Strict perimeter rules. The database only accepts traffic from the application tier, and the app tier only accepts traffic from the load balancer.
- **Private Compute:** EC2 instances are securely isolated in private subnets, using a NAT Gateway to fetch system updates (Apache).
- **Remote State Handling:** Configured S3 backend with locking to prevent state corruption during concurrent deployments.

## Challenges & Troubleshooting

During the build, I encountered and resolved several complex systems engineering challenges:

- **NAT Gateway Routing & Yum Timeouts:** EC2 instances in the private subnets were failing their `cloud-init` bootstrap scripts with connection timeouts. I traced the issue to a missing route in the private route table and resolved it by deploying a NAT Gateway in the public subnet, establishing a secure outbound path for packages.
- **ALB Subnet Inheritance:** The Load Balancer was initially returning connection timeouts despite healthy target groups. I debugged the module inputs and discovered the ALB had been placed in the private subnets. I rerouted the module variables to map the ALB to the public subnets, restoring internet-facing ingress.
- **State Drift Management:** Handled `ResourceAlreadyExists` errors by utilizing `terraform import` to reconcile out-of-band cloud changes with the local Terraform state, preserving the database lifecycle without forced recreation.

## Usage

**Prerequisites:** AWS CLI configured, Terraform installed.

1. Clone the repository.

2. Initialize the working directory:

```bash
 terraform init
```

3. Create a terraform.tfvars file (git-ignored) and add your database credentials:

```bash
  db_username = "YourUserName"
  db_password = "YourSecurePassword"
  db_name = "YourDatabaseName"
```

4. Review the execution plan:

```bash
  terraform plam
```

5. Provision the infrastructure:

```bash
  terraform apply
```

6. Access the application via the ALB DNS name provided in the Terraform outputs.

## Cleanup

To avoid incurring AWS charges, destroy the infrastructure when not in use:

```bash
  terraform destroy
```
