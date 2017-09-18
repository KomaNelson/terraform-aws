variable "aws_region" {
  description = "Region for the VPC"
  default = "eu-west-1"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "10.0.0.0/16"
}

#Public A
variable "public_subnet_cidr_1a" {
  description = "CIDR for the public subnet"
  default = "10.0.1.0/24"
}

#Public B
variable "public_subnet_cidr_1b" {
  description = "CIDR for the public subnet"
  default = "10.0.2.0/24"
}

#Public C
variable "public_subnet_cidr_1c" {
  description = "CIDR for the public subnet"
  default = "10.0.3.0/24"
}

#Private A
variable "private_subnet_cidr_1a" {
  description = "CIDR for the private subnet"
  default = "10.0.4.0/24"
}

#Private B
variable "private_subnet_cidr_1b" {
  description = "CIDR for the private subnet"
  default = "10.0.5.0/24"
}

#Private C
variable "private_subnet_cidr_1c" {
  description = "CIDR for the private subnet"
  default = "10.0.6.0/24"
}

variable "ami" {
  description = "Amazon Debian AMI"
  default = "ami-402f1a33"
}

variable "key_path" {
  description = "SSH Public Key path"
  default = "/Users/nelsonkoma/.ssh/id_rsa.pub"
}
