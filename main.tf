# providers
# provider "aws" {
    # region = "ap-south-1"
    # access_key = 
    # secret_key = 
# }

provider "aws" {}

# variables
# variable "dev-vpc-cidr-block" {
#     description = "Dev VPC cidr block"
# }

# variable "java-app-subnet-1-cidr-block" {
#     description = "Subnet-1 cidr block"
#     default = "10.0.10.0/24"
#     type = string
#     # type = list(string)
# }

# variable "java-app-subnet-2-cidr-block" {
#     description = "Subnet-2 cidr block"
# }

variable "cidr_blocks" {
    description = "cidr blocks and name tags for vpc and subnets"
    # type = list(string)
    type = list(object({
        cidr_block = string
        name = string
    }))
}

variable "environment" {
    description = "deployment environment"
}

# set environment variable TF_VAR_availability_zone=<zone>
variable "availability_zone" {}

# data sources
data "aws_vpc" "default-vpc" {
    default = true
}

# resources
resource "aws_vpc" "java-app-vpc" {
    # cidr_block = var.cidr_blocks[0]
    cidr_block = var.cidr_blocks[0].cidr_block
    tags = {
        # Name: var.environment
        Name: var.cidr_blocks[0].name
    }
}

resource "aws_subnet" "java-app-subnet-1" {
    vpc_id = aws_vpc.java-app-vpc.id
    # cidr_block = var.cidr_blocks[1]
    cidr_block = var.cidr_blocks[1].cidr_block
    availability_zone = var.availability_zone

    tags = {
        Name: var.cidr_blocks[1].name
    }
}

# resource "aws_subnet" "java-app-subnet-2" {
#     vpc_id = data.aws_vpc.default-vpc.id
#     cidr_block = var.java-app-subnet-2-cidr-block
#     availability_zone = "ap-south-1b"

#     tags = {
#         Name: "subnet-default-vpc"
#     }
# }

# outputs
output "java-app-vpc-id" {
    value = aws_vpc.java-app-vpc.id
}

output "java-app-subnet-id" {
    value = aws_subnet.java-app-subnet-1.id
}
