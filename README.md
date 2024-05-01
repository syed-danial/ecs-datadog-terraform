# Running AWS ECS Service with DataDog Lambda Forwarder Integration using Terraform

## Prerequisites

- AWS account credentials with appropriate permissions.
- Terraform installed on your local machine.
- DataDog account and API key for Lambda Forwarder integration.

## Steps

1. **Clone Repository:** Clone the repository to your local machine.
   
git clone https://github.com/syed-danial/ecs-datadog-terraform.git


2. **Navigate to Directory:** Change directory to the Terraform project folder.

cd <project_folder>


3. **Initialize Terraform:** Initialize Terraform and download required providers.

terraform init

4. **Select Workspace:** If using multiple environments, select the appropriate workspace.

terraform workspace select <workspace_name>

5. **Review Variables:** Review and update variables in `variables.tf` file as per your requirements. Ensure to provide DataDog API key and other necessary parameters.

6. **Apply Changes:** Apply Terraform changes to create or update infrastructure.

terraform apply

7. **Verify Deployment:** After successful deployment, verify the ECS service and Lambda Forwarder integration in your AWS Management Console and DataDog dashboard.

## Terraform Modules

- **ecs-cluster:** Module for creating ECS cluster.
- **ecs-service:** Module for defining ECS service with tasks and containers.
- **lambda-forwarder:** Module for configuring DataDog Lambda Forwarder.

## Workspaces

Workspaces are utilized for managing multiple environments such as `dev`, `staging`, and `production`. Each workspace maintains its own state and configuration.

To create or switch to a workspace, use the following Terraform commands:

terraform workspace new <workspace_name>
terraform workspace select <workspace_name>

## Clean Up

To clean up and destroy the resources created by Terraform, use the following command:

terraform destroy

## Contributing

Contributions to improve this guide or add new features are welcome! Feel free to open a pull request.

