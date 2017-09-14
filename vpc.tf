# Define our VPC
resource "aws_vpc" "ge_aws" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "ge-aws-vpc"
  }
}

# Define the public subnet
resource "aws_subnet" "public-subnet" {
  vpc_id = "${aws_vpc.ge_aws.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "eu-west-1"

  tags {
    Name = "Web Public Subnet"
  }
}

# Define the private subnet
resource "aws_subnet" "private-subnet" {
  vpc_id = "${aws_vpc.ge_aws.id}"
  cidr_block = "${var.private_subnet_cidr}"
  availability_zone = "eu-west-1"

  tags {
    Name = "Controllers Private Subnet"
  }
}

# Define the internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.ge_aws.id}"

  tags {
    Name = "VPC IGW"
  }
}

# Define the route table
resource "aws_route_table" "web-public-rt" {
  vpc_id = "${aws_vpc.ge_aws.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "Public Subnet RT"
  }
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "web-public-rt" {
  subnet_id = "${aws_subnet.public-subnet.id}"
  route_table_id = "${aws_route_table.web-public-rt.id}"
}

# Define the controller security group for public subnet
resource "aws_security_group" "sgcontroller" {
  name = "vpc_controller"
  description = "Allow incoming HTTP connections & SSH access"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }

  vpc_id="${aws_vpc.ge_aws.id}"

  tags {
    Name = "Controllers SG"
  }
}

# Define the public worker security group for private subnet
resource "aws_security_group" "sgpublicworker"{
  name = "sg_public_worker"
  description = "Allow traffic from public subnet"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  vpc_id = "${aws_vpc.ge_aws.id}"

  tags {
    Name = "workers SG"
  }
}

# Define the boot node security group for private subnet
resource "aws_security_group" "sgboot"{
  name = "sg_boot"
  description = "Allow traffic from public subnet"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  vpc_id = "${aws_vpc.ge_aws.id}"

  tags {
    Name = "Boot SG"
  }
}
