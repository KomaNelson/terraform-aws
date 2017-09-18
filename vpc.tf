# Define our VPC
resource "aws_vpc" "ge_aws" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "ge-aws-vpc"
  }
}

# Create a public subnet in the AZ eu-west-1a
resource "aws_subnet" "public-subnet-1a" {
  vpc_id = "${aws_vpc.ge_aws.id}"
  cidr_block = "${var.public_subnet_cidr_1a}"
  availability_zone = "eu-west-1a"

  tags {
    Name = "Public Subnet AZ eu-west-1a"
  }
}
resource "aws_subnet" "public-subnet-1b" {
  vpc_id = "${aws_vpc.ge_aws.id}"
  cidr_block = "${var.public_subnet_cidr_1b}"
  availability_zone = "eu-west-1b"

  tags {
    Name = "Public Subnet AZ eu-west-1b"
  }
}
resource "aws_subnet" "public-subnet-1c" {
  vpc_id = "${aws_vpc.ge_aws.id}"
  cidr_block = "${var.public_subnet_cidr_1c}"
  availability_zone = "eu-west-1c"

  tags {
    Name = "Public Subnet AZ eu-west-1c"
  }
}

# Create a private subnet in all the available zones
resource "aws_subnet" "private-subnet-1a" {
  vpc_id = "${aws_vpc.ge_aws.id}"
  cidr_block = "${var.private_subnet_cidr_1a}"
  availability_zone = "eu-west-1a"

  tags {
    Name = "Private Subnet AZ eu-west-1a"
  }
}
resource "aws_subnet" "private-subnet-1b" {
  vpc_id = "${aws_vpc.ge_aws.id}"
  cidr_block = "${var.private_subnet_cidr_1b}"
  availability_zone = "eu-west-1b"

  tags {
    Name = "Private Subnet AZ eu-west-1b"
  }
}
resource "aws_subnet" "private-subnet-1c" {
  vpc_id = "${aws_vpc.ge_aws.id}"
  cidr_block = "${var.private_subnet_cidr_1c}"
  availability_zone = "eu-west-1c"

  tags {
    Name = "Private Subnet AZ eu-west-1c"
  }
}

# Define the internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.ge_aws.id}"

  tags {
    Name = "VPC IGW"
  }
}

# Create an EIP for the NAT Gateway
resource "aws_eip" "nat" {
  vpc      = true
  depends_on = ["aws_internet_gateway.gw"]
}

# Create a NAT Gateway
resource "aws_nat_gateway" "nat" {
    allocation_id = "${aws_eip.nat.id}"
    subnet_id = "${aws_subnet.public-subnet-1a.id}"
    depends_on = ["aws_internet_gateway.gw"]
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

#Private Route Table
resource "aws_route_table" "private_route_table" {
  vpc_id = "${aws_vpc.ge_aws.id}"

  tags {
    Name = "Private Route Table"
  }
}

# Connect eu_west_1a to public route table
resource "aws_route_table_association" "public_eu_west_1a" {
  subnet_id = "${aws_subnet.public-subnet-1a.id}"
  route_table_id = "${aws_vpc.ge_aws.main_route_table_id}"
}

# Connect eu_west_1b to private route table
resource "aws_route_table_association" "private_eu_west_1b" {
  subnet_id = "${aws_subnet.private-subnet-1b.id}"
  route_table_id = "${aws_route_table.private_route_table.id}"
}
#  Connect eu_west_1c to private route table
resource "aws_route_table_association" "private_eu_west_1c" {
  subnet_id = "${aws_subnet.private-subnet-1c.id}"
  route_table_id = "${aws_route_table.private_route_table.id}"
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
    cidr_blocks = ["${var.public_subnet_cidr_1a}","${var.public_subnet_cidr_1b}",
    "${var.public_subnet_cidr_1b}"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.public_subnet_cidr_1a}","${var.public_subnet_cidr_1b}",
    "${var.public_subnet_cidr_1c}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr_1a}","${var.public_subnet_cidr_1b}",
    "${var.public_subnet_cidr_1c}"]
  }

  vpc_id = "${aws_vpc.ge_aws.id}"

  tags {
    Name = "public workers SG"
  }
}

# Define the private worker security group for private subnet
resource "aws_security_group" "sgprivateworker"{
  name = "sg_private_worker"
  description = "Allow traffic from private subnet"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${var.private_subnet_cidr_1a}","${var.private_subnet_cidr_1b}",
    "${var.private_subnet_cidr_1b}"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.private_subnet_cidr_1a}","${var.private_subnet_cidr_1b}",
    "${var.private_subnet_cidr_1c}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.private_subnet_cidr_1a}","${var.private_subnet_cidr_1b}",
    "${var.private_subnet_cidr_1c}"]
  }

  vpc_id = "${aws_vpc.ge_aws.id}"

  tags {
    Name = "private workers SG"
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
    cidr_blocks = ["${var.public_subnet_cidr_1a}","${var.public_subnet_cidr_1b}",
    "${var.public_subnet_cidr_1c}"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.public_subnet_cidr_1a}","${var.public_subnet_cidr_1b}",
    "${var.public_subnet_cidr_1c}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr_1a}","${var.public_subnet_cidr_1b}",
    "${var.public_subnet_cidr_1c}"]
  }

  vpc_id = "${aws_vpc.ge_aws.id}"

  tags {
    Name = "Boot SG"
  }
}
