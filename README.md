# Terraform

Terraform is an infrastructure as code (IaC) tool that allows you to create, manage, and update infrastructure resources such as virtual machines, networks, and storage in a repeatable, scalable, and automated way.

## What is Infrastructure as Code (IaC)?

Infrastructure as Code (IaC) is a practice of managing and provisioning infrastructure using code instead of manual processes. By treating infrastructure as code, teams can version control their infrastructure, automate the provisioning process, and improve collaboration between different teams. IaC enables teams to make changes to infrastructure in a safe and repeatable way, and it helps to reduce the risk of human error and inconsistencies.

## Why do we use terraform?

Terraform is a tool for building, changing, and versioning infrastructure in a safe, repeatable way. It enables teams to manage infrastructure as code, providing a single source of truth for the infrastructure and ensuring that it is always in the desired state. Terraform can be used to manage infrastructure across multiple cloud providers and on-premises infrastructure, and it supports a wide range of resource types.

## What is a Resource?

In Terraform, a resource is a declarative representation of a component in a cloud infrastructure, such as a virtual machine, database, or network interface. Resources define the desired state of the component, and Terraform uses the resource definition to create, modify, or delete the component as needed.

## What is a Provider?

In Terraform, a provider is a plugin that interfaces with a specific cloud infrastructure provider or service. Providers define the resources that Terraform can manage, as well as the methods for creating, updating, and deleting those resources. Examples of providers include AWS, Google Cloud, and Microsoft Azure.

## What is the State file in terraform? What’s the importance of it ?

The Terraform state file is a JSON file that stores the state of the infrastructure managed by Terraform. It includes information about the resources that have been created, their current state, and any dependencies between them. The state file is critical to Terraform's operation, as it is used to plan and execute changes to the infrastructure. The state file should be kept in a safe and secure location, as it contains sensitive information about the infrastructure.

## What is Desired and Current State?

In Terraform, the desired state is the state that you want your infrastructure to be in, as defined in your Terraform configuration files. The current state is the actual state of the infrastructure, as represented in the Terraform state file. When you run terraform apply, Terraform compares the desired state with the current state and makes changes as needed to bring the infrastructure into the desired state.

1) Terraform is an open source project created by HashiCorp and written in Go programming language.
2) Terraform is an infrastructure as a code software tool.
3) Infrastructure as a code is the process of managing infrastructure in a file or files rather than manually configuring resources in a user interface (UI).
4) In Terraform resources are nothing but virtual machines, Elastic IP, Security Group, Network interfaces.
5) Terraform Code is written in the Hashicorp Configuration Language (HCL) in files with the extension .tf 
6) Terraform allows users to use Hashicorp Configuration Language (HCL) to create the files containing definitions of their desired resources.
7) Terraform Supports almost all cloud providers (AWS, AZURE, GCP, Openstack etc.)
8) To automate infrastructure creation we will use Terraform.

### Advantages of DevOps

1) Speed
2) Rapid development
3) Quick releases
4) Reliability
5) Security
6) Client satisfaction
7) Teams collaboration

## Meta-arguments and its use in Terraform.

Meta-arguments in Terraform are special configuration options that are not associated with any specific resource but provide instructions or configuration for how Terraform itself should behave. These meta-arguments are typically defined within a provider block or a terraform block in your Terraform configuration. They help you manage the behaviour of Terraform itself or configure the interaction with providers.

## Modules

Modules are containers for multiple resources that are used together. A module consists of a collection of .tf and/or .tf.json files kept together in a directory.
A module can call other modules, which lets you include the child module's resources into the configuration in a concise way.
Modules can also be called multiple times, either within the same configuration or in separate configurations, allowing resource configurations to be packaged and re-used.


# Install Terraform

Terraform website [link](https://developer.hashicorp.com/terraform/downloads).


# Setup Terraform to work with AWS

1) Install AWS CLI
   You can download and install the AWS CLI from here: https://aws.amazon.com/cli/

2) Configure AWS Credentials
   To interact with AWS from Terraform, you'll need to set up AWS credentials.

```
aws configure
```

You will be prompted to enter your AWS Access Key ID, Secret Access Key, default region, and output format. Make sure to provide the necessary information.

## Define the AWS provider

```
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.0.0"  # Specify the desired version
    }
  }
}

provider "aws" {
  region = "us-west-2"
}
```


## Terraform Commands 

```terraform init ```        
Prepare your working directory for other commands

```terraform validate```
Check whether the configuration is valid

```terraform plan```          
Show changes required by the current configuration

```terraform apply ```        
create or update infrastructure

```terraform destroy```       
Destroy previously-created infrastructure

```terraform fmt```           
Reformat your configuration in the standard style

```terraform console```      
Try Terraform expressions at an interactive command prompt

```terraform force-unlock```  
Release a stuck lock on the current workspace

```terraform get```           
Install or upgrade remote Terraform modules

```terraform graph```         
Generate a Graphviz graph of the steps in an operation

```terraform import```        
Associate existing infrastructure with a Terraform resource

```terraform login```         
Obtain and save credentials for a remote host

```terraform logout```        
Remove locally-stored credentials for a remote host

```terraform metadata```      
Metadata related commands

```terraformoutput```        
Show output values from your root module

```terraform providers```     
Show the providers required for this configuration

```terraform refresh```       
Update the state to match remote systems

```terrafrom show ```         
Show the current state or a saved plan

```terraform state```         
Advanced state management

```terraform taint```         
Mark a resource instance as not fully functional

```terraform untaint```       
Remove the 'tainted' state from a resource instance

```terraform version```       
Show the current Terraform version

```terraform workspace```     
Workspace management

# Terraform Variables

### Declare Variables

In your Terraform configuration files (typically with a .tf extension), you can declare variables using the `variable` block. 

variable.tf

```
variable "aws_region" {
  description = "The AWS region where resources will be created."
  default     = "us-east-1"
}

variable "instance_type" {
  description = "The type of EC2 instance to launch."
  default     = "t2.micro"
}
```

### Reference Variables

You can reference these variables in your resource blocks or other parts of your configuration using the `var` function.

```
provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type
}

```

### Output Value

Terraform output variables allow you to expose specific information or values from your infrastructure deployment for use outside of your Terraform configuration. In your Terraform configuration, you can define output variables using the `output` block. 

```
output "instance_ip" {
  description = "The public IP  of the EC2 instance."
  value       = aws_instance.example.public_ip
}
```

### Example:

variable.tf
```
variable "ami1" {
    description = "amazon machine image"
    type = string
    default = "ami-0f5ee92e2d63afc18"
}

variable "instance_type1" {
    description = "ec2 instance type"
    type = string
    default = "t2.micro"
}

variable "instance_count" {
    description = "subnet for instance"
    type = number
    default = 2
}
```

main.tf

```
//Using variables Deploying EC2. 

//Deploying Ec2 Instance

resource "aws_instance" "my_public_instance" {
  ami           = var.ami1
  count         = var.instance_count
  instance_type = var.instance_type1
  key_name      = "mydemokey"
  vpc_security_group_ids = [aws_security_group.server_security_group.id]
  user_data = "${file("user_data1.sh")}"
  tags = {
    Name = "EC2_Instance-${count.index}"
  }
}

// Define an output variable to expose the public IP address of the EC2 instance

output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.my_public_instance.public_ip
}

//Deploying Ec2 instance Security group

resource "aws_security_group" "server_security_group" {
  name        = "EC2_server_security_group1"
  description = "enabled ssh and http ports"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    
  tags = {
    Name = "EC2_SG"
  }
}
```
## Terraform tfvars

Terraform `.tfvars` files, also known as variable definition files or variable files, are used to provide input values for Terraform variables. These files allow you to specify values for variables in a structured and reusable manner. `.tfvars` files are commonly used to separate variable values from the main Terraform configuration, making it easier to manage configurations for different environments or scenarios.

1) Create a `.tfvars` File
Name this file according to your preference, but it's common to name it something like variables.tfvars, dev.tfvars, prod.tfvars, etc., to indicate its purpose or environment.

variable.tfvars
```
aws_region = "us-west-2"
instance_type = "t2.micro"
```

When running Terraform commands like terraform apply or terraform plan, you can specify the `.tfvars` file using the `-var-file`
```
terraform apply -var-file=variables.tfvars
```

If you name your `.tfvars` file according to a specific pattern (e.g., terraform.tfvars or *.auto.tfvars), Terraform will automatically load it without needing to specify it with `-var-file`.

## Conditional Expressions
Conditional expressions in Terraform are used to define conditional logic within your configurations. They allow you to make decisions or set values based on conditions. Conditional expressions are typically used to control whether resources are created or configured based on the evaluation of a condition.

The basic structure of a conditional expression is

```
condition ? expression_if_true : expression_if_false
```
The `condition` is evaluated first. If it's true, the value of `expression_if_true` is returned; otherwise, the value of `expression_if_false` is returned.

### Example:
```
variable "environment" {
  description = "Environment"
  type        = string
  default     = "development"
}

variable "production_subnet_cidr" {
  description = "CIDR block for production subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "development_subnet_cidr" {
  description = "CIDR block for development subnet"
  type        = string
  default     = "10.0.2.0/24"
}

resource "aws_security_group" "my-SG" {
  name        = "my-sg"
  description = "my security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.environment == "production" ? [var.production_subnet_cidr] : [var.development_subnet_cidr]
  }
}
```

# Modules

Modules are containers for multiple resources that are used together. A module consists of a collection of `.tf` files kept together in a directory. A module can call other modules, which lets you include the child module's resources into the configuration in a concise way. Modules can also be called multiple times, either within the same configuration or in separate configurations, allowing resource configurations to be packaged and re-used. 

Module Inputs (Variables):

1) Modules can have input variables that allow users to customize the behavior of the module.
2) Input variables are defined using the variable block in the module's configuration.
3) Users of the module provide values for these variables when they call the module.

Module Outputs:

1) Modules can define output values that allow users to access information or results from the module.
2) Output values are defined using the output block in the module's configuration.

```
variable "ami" {
  description = "The AMI ID for the EC2 instance"
}

// main.tf (inside the module directory)

resource "aws_instance" "example" {
  ami           = var.ami
  instance_type = var.instance_type
}

variable "instance_type" {
  description = "The instance type for the EC2 instance"
}

output "instance_id" {
  description = "The ID of the created EC2 instance"
  value       = aws_instance.example.id
}
```

# Terraform State File

Terraform uses a state file to keep track of the resources it manages and their current states. The state file is a crucial component of Terraform's functionality, as it allows Terraform to know the state of your infrastructure and make decisions about what changes need to be applied during subsequent runs.

Terraform state file is a JSON file that contains detailed information about the resources declared in your Terraform configuration files. It includes data such as resource IDs, attributes, dependencies, and metadata. This state information is used by Terraform to plan and apply changes to your infrastructure.

## Location of the State File:

By default, Terraform stores the state file locally in a file named terraform.tfstate in the same directory as your configuration files. However, it's not recommended to use the local state file in production environments or when collaborating with a team. Instead, you should use a remote backend like AWS S3, Azure Blob Storage, Google Cloud Storage, or HashiCorp Consul to store the state file securely.

### Why Is the State File Important?

1) Resource Tracking: It keeps track of the resources Terraform manages and their current states. This information is essential for Terraform to know what resources already exist in your cloud provider and what changes need to be applied.

2) Dependency Management: It records the dependencies between resources. This information helps Terraform determine the correct order in which to create, update, or delete resources to maintain consistency.

3) Attribute Values: It stores the values of resource attributes. This allows Terraform to determine whether a resource needs updating based on differences between the desired state (your configuration) and the actual state (from the state file).

4) Locking: In a collaborative environment, the state file can be used for locking to prevent multiple users or automation processes from concurrently modifying the state, which could lead to conflicts and inconsistencies.

## Security Considerations:

Since the state file contains sensitive information about your infrastructure, it's crucial to protect it from unauthorized access. If you're using a remote backend, ensure proper access controls and encryption are in place. For added security, enable state locking to prevent concurrent writes to the state.

### Terraform backend:

Terraform, the term "backend" refers to the configuration that determines where and how Terraform stores its state files. The backend configuration specifies where Terraform should store the state data for your infrastructure. Terraform supports various backends, including remote storage solutions and local storage. 

1) Create a `backend.tf` file in your Terraform project directory.

2) Add the backend configuration block to the `backend.tf` file based on your chosen backend type and its specific settings.

### Remote Backends e.g., S3:

1) Create an S3 Bucket: Create an S3 bucket in your AWS account to store the Terraform state. Ensure that the appropriate IAM permissions are set up.

```
// Creating Bucket

resource "aws_s3_bucket" "my_bucket" {
  bucket = "pradipkv247" 
}
```

2) Create a DynamoDB Table:

```
resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-lock"      // Replace "terraform-lock" with the desired DynamoDB table name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  
  attribute {
    name = "LockID"
    type = "S"
  }
}
```

3) Configure Remote Backend in Terraform:

```
// In your Terraform configuration file main.tf, define the remote backend.

terraform {
  backend "s3" {
    bucket         = "pradipkv247" 
    key            = "terraform_state_files/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}
```

Replace `pradipkv247` and `terraform_state_files/terraform.tfstate` with your S3 bucket and desired state file path.

# Provisioners

Provisioners are a mechanism for running scripts or commands on the remote resources after they are created or updated. Provisioners are typically used for tasks such as configuring software on a virtual machine, initializing databases, or performing any other post-resource creation tasks.

Provisioners should be used with caution because they introduce a level of imperative behavior in what is otherwise a declarative infrastructure-as-code approach. It's generally recommended to rely on native configuration management tools (e.g., Ansible, Chef, Puppet) for more complex configuration tasks and use provisioners for simple tasks or as a last resort when no other option is available.

## There are two types of provisioners

### 1) Local-Exec Provisioners:

 These provisioners are often used for local tasks, like creating SSH keys, generating configuration files, or preparing files that will be uploaded to remote resources.

 ```
 resource "aws_instance" "my_ec2_instance" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  provisioner "local-exec" {
    command = "echo 'Hello, my name is pradip' > hello.txt"
  }
}

 ```

`local-exec` provisioner runs a command that creates a file called hello.txt with the content "Hello, my name is pradip" on the local machine.

 ### 2) Remote-Exec Provisioners:

 Remote-exec provisioners run scripts or commands on the remote resource. These provisioners are typically used for configuring and initializing resources after they are created. 

 ```
 resource "aws_instance" "example" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
    ]
  }
}

 ```
`remote-exec` provisioner uses an SSH connection to run commands on the newly created AWS EC2 instance. It updates the package cache and installs the `Nginx` web server.

# Workspace

Workspaces allow you to create isolated environments within a single Terraform configuration to manage different sets of infrastructure resources. This can be useful for various purposes, such as managing multiple environments (e.g., development, staging, production) or isolating different projects within the same configuration.

1) Create a New Workspace:

```
terraform workspace new dev
terraform workspace new stage
terraform workspace new prod
```

2) List Workspaces:

```
terraform workspace list
```

3) Switch Between Workspaces:

```
terraform workspace select dev
```

4) Delete a Workspace:

```
terraform workspace delete dev
```
5) workspace usage

```
terraform workspace -h
Usage: terraform [global options] workspace

  new, list, show, select and delete Terraform workspaces.

Subcommands:
    delete    Delete a workspace
    list      List Workspaces
    new       Create a new workspace
    select    Select a workspace
    show      Show the name of the current workspace
```


