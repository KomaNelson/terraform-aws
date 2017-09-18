# Define SSH key pair for our instances
resource "aws_key_pair" "default" {
  key_name = "vpctestkeypair"
  public_key = "${file("${var.key_path}")}"
}

#Template to rename hostnames
data "template_file" "user_data" {
  template = "${file("user_data.tpl")}"
}

# Define the Boot Node
resource "aws_instance" "prd-ge-boot" {
   ami  = "${var.ami}"
   instance_type = "c3.large"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.public-subnet-1a.id}"
   vpc_security_group_ids = ["${aws_security_group.sgboot.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   private_ip = "10.0.4.255"
   user_data = "${replace(data.template_file.user_data.rendered, "%%HOSTNAME%%", "prd-ge-boot")}"
   #user_data = "${file("scripts/install.sh")}"

  tags {
    Name = "prd-ge-boot.ie.p16n.org"
  }
}

# Define the public workers inside the public subnet
resource "aws_instance" "prd-ge-public01" {
   ami  = "${var.ami}"
   instance_type = "c3.large"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.public-subnet-1a.id}"
   vpc_security_group_ids = ["${aws_security_group.sgpublicworker.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   private_ip = "10.0.1.5"
   user_data = "${replace(data.template_file.user_data.rendered, "%%HOSTNAME%%", "prd-ge-public01")}"
   #user_data = "${file("scripts/install.sh")}"

  tags {
    Name = "prd-ge-public01.ie.p16n.org"
  }
}
resource "aws_instance" "prd-ge-public02" {
   ami  = "${var.ami}"
   instance_type = "c3.large"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.public-subnet-1b.id}"
   vpc_security_group_ids = ["${aws_security_group.sgpublicworker.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   private_ip = "10.0.2.5"
   user_data = "${replace(data.template_file.user_data.rendered, "%%HOSTNAME%%", "prd-ge-public02")}"
   #user_data = "${file("scripts/install.sh")}"

  tags {
    Name = "prd-ge-public02.ie.p16n.org"
  }
}
resource "aws_instance" "prd-ge-public03" {
   ami  = "${var.ami}"
   instance_type = "c3.large"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.public-subnet-1c.id}"
   vpc_security_group_ids = ["${aws_security_group.sgpublicworker.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   private_ip = "10.0.3.5"
   user_data = "${replace(data.template_file.user_data.rendered, "%%HOSTNAME%%", "prd-ge-public03")}"
   #user_data = "${file("scripts/install.sh")}"

  tags {
    Name = "prd-ge-public03.ie.p16n.org]"
  }
}

# Define the private workers inside the private subnet
resource "aws_instance" "prd-ge-worker01" {
   ami  = "${var.ami}"
   instance_type = "c3.large"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.private-subnet-1a.id}"
   vpc_security_group_ids = ["${aws_security_group.sgprivateworker.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   private_ip = "10.0.4.10"
   user_data = "${replace(data.template_file.user_data.rendered, "%%HOSTNAME%%", "prd-ge-worker01")}"
   #user_data = "${file("scripts/install.sh")}"

  tags {
    Name = "prd-ge-worker01.ie.p16n.org"
  }
}
resource "aws_instance" "prd-ge-worker02" {
   ami  = "${var.ami}"
   instance_type = "c3.large"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.private-subnet-1b.id}"
   vpc_security_group_ids = ["${aws_security_group.sgprivateworker.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   private_ip = "10.0.5.10"
   user_data = "${replace(data.template_file.user_data.rendered, "%%HOSTNAME%%", "prd-ge-worker02")}"
   #user_data = "${file("scripts/install.sh")}"

  tags {
    Name = "prd-ge-worker02.ie.p16n.org"
  }
}
resource "aws_instance" "prd-ge-worker03" {
   ami  = "${var.ami}"
   instance_type = "c3.large"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.private-subnet-1c.id}"
   vpc_security_group_ids = ["${aws_security_group.sgprivateworker.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   private_ip = "10.0.6.10"
   user_data = "${replace(data.template_file.user_data.rendered, "%%HOSTNAME%%", "prd-ge-worker03")}"
   #user_data = "${file("scripts/install.sh")}"

  tags {
    Name = "prd-ge-worker03.ie.p16n.org"
  }
}
resource "aws_instance" "prd-ge-worker04" {
   ami  = "${var.ami}"
   instance_type = "c3.large"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.private-subnet-1a.id}"
   vpc_security_group_ids = ["${aws_security_group.sgprivateworker.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   private_ip = "10.0.4.11"
   user_data = "${replace(data.template_file.user_data.rendered, "%%HOSTNAME%%", "prd-ge-worker04")}"
   #user_data = "${file("scripts/install.sh")}"

  tags {
    Name = "prd-ge-worker04.ie.p16n.org"
  }
}
resource "aws_instance" "prd-ge-worker05" {
   ami  = "${var.ami}"
   instance_type = "c3.large"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.private-subnet-1b.id}"
   vpc_security_group_ids = ["${aws_security_group.sgprivateworker.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   private_ip = "10.0.5.11"
   user_data = "${replace(data.template_file.user_data.rendered, "%%HOSTNAME%%", "prd-ge-worker05")}"
   #user_data = "${file("scripts/install.sh")}"

  tags {
    Name = "prd-ge-worker05.ie.p16n.org"
  }
}
resource "aws_instance" "prd-ge-worker06" {
   ami  = "${var.ami}"
   instance_type = "c3.large"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.private-subnet-1c.id}"
   vpc_security_group_ids = ["${aws_security_group.sgprivateworker.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   private_ip = "10.0.6.11"
   user_data = "${replace(data.template_file.user_data.rendered, "%%HOSTNAME%%", "prd-ge-worker06")}"
   #user_data = "${file("scripts/install.sh")}"

  tags {
    Name = "prd-ge-worker06.ie.p16n.org"
  }
}

# Define the controllers inside the public subnet
resource "aws_instance" "prd-ge-controller01" {
   ami  = "${var.ami}"
   instance_type = "c3.large"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.public-subnet-1a.id}"
   vpc_security_group_ids = ["${aws_security_group.sgcontroller.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   private_ip = "10.0.4.5"
   user_data = "${replace(data.template_file.user_data.rendered, "%%HOSTNAME%%", "prd-ge-controller01")}"
   #user_data = "${file("scripts/install.sh")}"

  tags {
    Name = "prd-ge-controller01.ie.p16n.org"
  }
}
resource "aws_instance" "prd-ge-controller02" {
   ami  = "${var.ami}"
   instance_type = "c3.large"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.public-subnet-1b.id}"
   vpc_security_group_ids = ["${aws_security_group.sgcontroller.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   private_ip = "10.0.5.5"
   user_data = "${replace(data.template_file.user_data.rendered, "%%HOSTNAME%%", "prd-ge-controller02")}"
   #user_data = "${file("scripts/install.sh")}"

  tags {
    Name = "prd-ge-controller02.ie.p16n.org"
  }
}
resource "aws_instance" "prd-ge-controller03" {
   ami  = "${var.ami}"
   instance_type = "c3.large"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.public-subnet-1c.id}"
   vpc_security_group_ids = ["${aws_security_group.sgcontroller.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   private_ip = "10.0.6.5"
   user_data = "${replace(data.template_file.user_data.rendered, "%%HOSTNAME%%", "prd-ge-controller03")}"
   #user_data = "${file("scripts/install.sh")}"

  tags {
    Name = "prd-ge-controller03.ie.p16n.org"
  }
}
