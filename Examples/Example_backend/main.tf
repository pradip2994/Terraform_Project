//Before Adding AWS provider install AWS CLI and configure AWS CLI
//ADD Secret Key,Access Key and Region 



// Deploying AWS Resources

// Deploying VPC

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "newVPC"
  }
}

// Deploying Public Subnet

resource "aws_subnet" "my_subnet1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Subnet1"
  }
}

// Deploying Internet gateway

resource "aws_internet_gateway" "my_vpc" {
  tags = {
    Name = "my_IGW"
  }
}

// Internet Gateway Attachement to VPC

resource "aws_internet_gateway_attachment" "my_vpc" {
  internet_gateway_id = aws_internet_gateway.my_vpc.id
  vpc_id           = aws_vpc.my_vpc.id
  
}

// Deploying Public Route Table

resource "aws_route_table" "my_route_table1" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "RouteTable"
  }
}

// Giving Routes to Internet Gateway to Public Route Table 

resource "aws_route" "default_route1" {
  route_table_id         = aws_route_table.my_route_table1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_vpc.id
  depends_on             = [aws_internet_gateway_attachment.my_vpc]
}



// Associations of Public subnet with Public Route table

resource "aws_route_table_association" "associate_subnet1" {
  subnet_id      = aws_subnet.my_subnet1.id
  route_table_id = aws_route_table.my_route_table1.id

}

// Deploying Public Instance

resource "aws_instance" "my_instance1" {
  ami           = var.ami1
  instance_type = var.instance_type1
  subnet_id     = aws_subnet.my_subnet1.id
  key_name      = "mydemokey"
  vpc_security_group_ids = [aws_security_group.server_a_security_group.id]
  user_data = "${file("user_data1.sh")}"
  tags = {
    Name = "Instance-1"
  }
}

// Deploying Public instance Security group

resource "aws_security_group" "server_a_security_group" {
  name        = "server_a_security_group1"
  description = "enabled ssh and http ports"
  vpc_id      = aws_vpc.my_vpc.id

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
    Name = "EC2Instance-SG"
  }
}

// Creating Bucket

resource "aws_s3_bucket" "my_bucket" {
  bucket = "pradipkv247" 
}

// Create a DynamoDB Table for State Locking

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-lock"    // Replace "terraform-lock" with the desired DynamoDB table name.
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  
  attribute {
    name = "LockID"
    type = "S"
  }
}
