
# Project: AWS Terraform GitHub Actions  
**Hosting a Static Website on DEV and PROD Environments via Modular Terraform & GitHub Actions**

---

> **NOTE:**  
> Please **fork this repository** for your own use.  
> Make sure to **set up your AWS credentials** as GitHub Secrets to enable Infrastructure as Code (IaC) provisioning.  
> **S3** and **DynamoDB** must be enabled and configured for the Terraform remote backend to function correctly.Certainly! Here’s the text you can add to your note:
> **For naming conventions in Terraform scripts, the kebab-case style (e.g., `alb-main`) is used. This improves readability and consistency across resources and modules.**

---

## Overview

This project demonstrates how to **provision, deploy, and manage a scalable static website on AWS** using **Terraform** (with a modular approach) and **GitHub Actions** for CI/CD.  
It features **two isolated environments** (DEV and PROD), automated infrastructure deployment and teardown, and environment-specific protection using GitHub Environments.

---

## Architecture

- **AWS Resources:**  
  - VPC, Subnets, Internet Gateway, Route Tables  
  - Application Load Balancer (ALB) and its Security Groups  
  - EC2 Instances (serving static HTML content)
  - Modularized Terraform code (`modules/` for `alb`, `alb-sg`, `ec2`, `ec2_sg`, `igw`, `route_table`, `subnet`, `vpc`)

- **Static Website Content:**  
  - Separate HTML files for DEV and PROD, stored under `html/dev/` and `html/prod/` respectively (e.g., `a.html`, `b.html`).

- **Configuration Files:**  
  - Environment-specific variable files:  
    - `environments/dev/terraform.tfvars`
    - `environments/prod/terraform.tfvars`
  - Remote backend configuration files:  
    - `backend-dev.tfbackend`
    - `backend-prod.tfbackend`

---

## CI/CD Workflow (GitHub Actions)

### 1. **Terraform Deployment Workflow (`deploy.yml`)**

- **Trigger:** Manual (`workflow_dispatch`) with environment selection (dev/prod)
- **Steps:**
  1. **Checkout code**
  2. **Setup Terraform**
  3. **Configure AWS credentials** (from repo/organization secrets)
  4. **Inject correct backend config**  
     - Copies the appropriate backend config (`backend-dev.tfbackend` or `backend-prod.tfbackend`) to `backend.tf` at runtime.
  5. **Terraform Init**  
     - Initializes the backend (only one backend config is present at a time to avoid conflicts).
  6. **Workspace selection/creation**  
     - Uses Terraform Workspaces to isolate state for each environment.
  7. **Terraform Plan & Apply**  
     - Applies changes using the environment-specific variable files.
  8. **Output**  
     - Displays Terraform outputs (e.g., ALB DNS, EC2 instance IDs).

### 2. **Terraform Destroy Workflow (`destroy.yml`)**

- **Trigger:** Manual (`workflow_dispatch`) with environment selection (dev/prod)
- **Steps:** Similar to deployment, but runs `terraform destroy` after selecting the workspace.

---

## Terraform Backend Strategy

**Problem:**  
Terraform supports only one backend configuration (`backend` block) per working directory. Having multiple backend configs (e.g., for dev and prod) with `.tf` extension causes errors (`Multiple backend blocks found`).  

**Solution:**  
- Store backend configs as `backend-dev.tfbackend` and `backend-prod.tfbackend` (no `.tf` extension).
- In the workflow, copy the relevant file to `backend.tf` **just before `terraform init`**.
- This ensures only one backend config is present and avoids conflicts.

---

## Environment Separation & Protection

- **Terraform Workspaces:**  
  - Isolates state between `dev` and `prod` (prevents resource overlap).

- **GitHub Environments:**  
  - Created `dev` and `prod` environments in repository settings.
  - **DEV:**  
    - No deployment protection rules (for rapid iteration/testing).
  - **PROD:**  
    - Deployment protection rules enforced:
      - **Review required by user:** `Aashwin11`
      - **Wait timer:** 1 minute before deployment can proceed

- **Secrets Management:**  
  - AWS credentials (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`) stored as encrypted GitHub Secrets, scoped per environment.

---

## Repository Structure

```
.
├── .gitignore
├── environments/
│   ├── dev/
│   │   └── terraform.tfvars
│   └── prod/
│       └── terraform.tfvars
├── html/
│   ├── dev/
│   │   ├── a.html
│   │   └── b.html
│   └── prod/
│       ├── a.html
│       └── b.html
├── modules/
│   ├── alb/
│   ├── alb-sg/
│   ├── ec2/
│   ├── ec2_sg/
│   ├── igw/
│   ├── route_table/
│   ├── subnet/
│   └── vpc/
├── backend-dev.tfbackend
├── backend-prod.tfbackend
├── main.tf
├── outputs.tf
├── variables.tf
├── deploy.yml        # GitHub Actions workflow for deployment
├── destroy.yml       # GitHub Actions workflow for destroy
└── README.md
```

---

## .gitignore

A `.gitignore` file is included to **safeguard sensitive or unnecessary files** from being committed to the repository.  
Typical entries might include:

```
# Local Terraform files
*.tfstate
*.tfstate.*
.terraform/
crash.log
*.tfvars
backend.tf

# IDE files
.vscode/
.idea/
.DS_Store
```

> This helps ensure that sensitive state files, backend configs, or local IDE settings are never pushed to the remote repository.

---

## How to Use

### **1. Deploy Infrastructure**
- Go to the **Actions** tab in GitHub.
- Select **Terraform Deployment Script** workflow.
- Click **Run workflow**, choose either `dev` or `prod`, and start the run.
- For `prod`, review and approve as required by deployment protection.

### **2. Destroy Infrastructure**
- Go to the **Terraform Destroy** workflow in Actions.
- Click **Run workflow**, choose the environment, and confirm.

---

## Features & Skills Demonstrated

- **Terraform Modularization:**  
  - Clean, reusable modules for AWS infrastructure components.

- **Multi-Environment Strategy:**  
  - Isolated environments for dev/prod via workspaces and variable files.

- **CI/CD with GitHub Actions:**  
  - Automated deployment and teardown workflows with manual triggers and environment-based logic.

- **Secure Credential Management:**  
  - AWS credentials managed securely as GitHub Secrets.

- **Deployment Protection:**  
  - GitHub Environments and protection rules for safe production releases.

- **Dynamic Backend Configuration:**  
  - Runtime backend config injection to avoid multiple backend block issues.

- **Infrastructure as Code Best Practices:**  
  - Clear separation of code, config, and environment data.

- **Version Control Hygiene:**  
  - Sensitive and unnecessary files are excluded from version control using `.gitignore`.

---

## 📸 Example Website Output

Each EC2 instance hosts a static HTML page that dynamically displays:
- The **instance ID** (`$(hostname)`)
- The **environment** (DEV or PROD)
- Custom styling and effects

---

## Author

**Aashwin11**

---

##  References

- [Terraform: Workspaces](https://developer.hashicorp.com/terraform/language/state/workspaces)
- [Terraform: Backends](https://developer.hashicorp.com/terraform/language/settings/backends/configuration)
- [GitHub Actions: Environments](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment)
- [GitHub Actions: Workflow Syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)

---

Feel free to use, fork, and adapt this project for your own AWS and Terraform learning or deployments. If you have suggestions or need enhancements, please open an issue or PR!
