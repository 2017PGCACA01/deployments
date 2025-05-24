# EC2-Based Infrastructure Deployment for `user_doc_ing`

This repository provisions an AWS infrastructure to run the `feature` branch of the [`user_doc_ing`](https://github.com/2017PGCACA01/user_doc_ing) application on EC2, using:

- **Auto Scaling Group (ASG)**
- **Application Load Balancer (ALB)**
- **Target Group**
- **Route 53 (custom domain support)**
- **Launch Template with User Data**

> **Note:** This setup does **not** utilize Kubernetes; the application runs directly on EC2 instances.

---

## 📁 Project Structure

```
.
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── user_data.sh
├── modules/
│ ├── ec2_instance/
│ ├── alb/
│ ├── asg/
│ └── route53/
└── README.md
```

## ⚙️ Prerequisites

Before deploying this infrastructure, ensure you have the following:

### AWS Resources

- **VPC**: A Virtual Private Cloud with at least two public subnets across different Availability Zones.
- **Route 53 Hosted Zone**: A public hosted zone for your domain.
- **Key Pair**: An existing EC2 Key Pair for SSH access to instances.

### Tools Installed

- **Terraform**: Infrastructure as Code tool.
- **AWS CLI**: Command-line tool for AWS services.
- **Git**: Version control system.

---

## Infrastructure Components

### EC2 Instance

- **Launch Template**: Defines the configuration for EC2 instances, including AMI, instance type, security groups, and user data script.
- **User Data Script**: Automates the installation of dependencies, cloning of the `feature` branch from the `user_doc_ing` repository, and starting the application.

### Auto Scaling Group (ASG)

- Ensures the desired number of EC2 instances are running.
- Automatically replaces unhealthy instances.
- Distributes instances across multiple Availability Zones for high availability.

### Application Load Balancer (ALB)

- Distributes incoming HTTP/HTTPS traffic across EC2 instances.
- Performs health checks to route traffic only to healthy instances.

### Target Group

- Registers EC2 instances to receive traffic from the ALB.
- Configured with health check settings to monitor instance health.

### Route 53

- DNS service that maps your domain name to the ALB.
- Provides an alias record pointing to the ALB's DNS name.

## Deployment Steps

1.  **Clone the repository**
    ```bash
    git clone https://github.com/your-org/ec2-infra-deploy.git
    cd ec2-infra-deploy
    ```
2.  **Update terraform.tfvars**
    Populate the terraform.tfvars file with your specific values:

        ```
        Copy code
        region          = "ap-south-1"
        vpc_id          = "vpc-xxxxxxx"
        subnet_ids      = ["subnet-xxxx", "subnet-yyyy"]
        zone_id         = "Zxxxxxxxxxx"
        record_name     = "app.example.com"
        ami_id          = "ami-xxxxxx" # Ubuntu or Amazon Linux
        key_name        = "your-ec2-keypair"
        ```

3.  **Initialize Terraform**
    ```
    terraform init
    ```
4.  **Apply the Terraform configuration**

    ```
    terraform apply

    ```

5.  **Access the Application**

    ```
    Once applied, your application will be available at         http://app.example.com or via the ALB DNS name.
    ```

## CI/CD Integration
To automate the deployment process, integrate this infrastructure with a CI/CD pipeline. Here's a high-level overview:

### Version Control

- Host your application code in a Git repository (e.g., GitHub, GitLab).

- Use branching strategies like GitFlow for managing feature development.

### Continuous Integration (CI)

- Set up a CI tool (e.g., Jenkins, GitHub Actions) to automate testing.

- On each commit or pull request, run unit tests and code quality checks.

### Continuous Deployment (CD)

- Upon successful tests, trigger Terraform to apply any - infrastructure changes.

- Use the CI/CD tool to SSH into EC2 instances or use AWS Systems Manager to deploy application updates.

### Monitoring and Alerts

- Integrate monitoring tools (e.g., CloudWatch, Prometheus) to observe application performance.

- Set up alerts for critical metrics to ensure high availability.

## User Data Script (user_data.sh)

The user_data.sh script performs the following actions on EC2 instance launch:

- Installs necessary dependencies (Python, pip, git)

- Clones the feature branch of the user_doc_ing application

- Installs Python packages

- Launches the Flask application on port 5000

Note: Ensure that the security group associated with the EC2 instances allows inbound traffic on port 5000.

## Clean Up

To destroy all resources created by this Terraform configuration:
`terraform destroy`

## Notes

- The EC2 instances are launched using a Launch Template that includes the user_data.sh script for boot-time provisioning.

- The ALB forwards HTTP traffic to the Target Group on port 5000.

- The ASG ensures high availability with automatic scaling and instance replacement.

- Route 53 is configured to map your custom domain name to the ALB.
