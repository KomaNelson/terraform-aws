# Define SSH key pair for our instances
resource "aws_key_pair" "default" {
  key_name = "vpctestkeypair"
  public_key = "${file("${var.key_path}")}"
}

# Define the Boot Node inside the public subnet
resource "aws_instance" "boot" {
   ami  = "${var.ami}"
   instance_type = "c3.large"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sgboot.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   private_ip = "10.0.2.1"
   user_data = "${file("scripts/install.sh")}"

  tags {
    Name = "boot"
  }
}

# Define the public workers inside the public subnet
resource "aws_instance" "publicworker01" {
   ami  = "${var.ami}"
   instance_type = "c3.large"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sgpublicworker.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   private_ip = "10.0.2.2"
   user_data = "${file("scripts/install.sh")}"

  tags {
    Name = "publicworker01"
  }
}
resource "aws_instance" "publicworker02" {
   ami  = "${var.ami}"
   instance_type = "c3.large"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sgpublicworker.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   private_ip = "10.0.2.3"
   user_data = "${file("scripts/install.sh")}"

  tags {
    Name = "publicworker02"
  }
}
resource "aws_instance" "publicworker03" {
   ami  = "${var.ami}"
   instance_type = "c3.large"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sgpublicworker.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   private_ip = "10.0.2.4"
   user_data = "${file("scripts/install.sh")}"

  tags {
    Name = "publicworker03"
  }
}

# Define the controllers inside the public subnet
resource "aws_instance" "controller01" {
   ami  = "${var.ami}"
   instance_type = "c3.large"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sgcontroller.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   private_ip = "10.0.2.10"
   user_data = "${file("scripts/install.sh")}"

  tags {
    Name = "controller01"
  }
}
resource "aws_instance" "controller02" {
   ami  = "${var.ami}"
   instance_type = "c3.large"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sgcontroller.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   private_ip = "10.0.2.11"
   user_data = "${file("scripts/install.sh")}"

  tags {
    Name = "controller02"
  }
}
resource "aws_instance" "controller03" {
   ami  = "${var.ami}"
   instance_type = "c3.large"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sgcontroller.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   private_ip = "10.0.2.12"
   user_data = "${file("scripts/install.sh")}"

  tags {
    Name = "controller03"
  }
}
