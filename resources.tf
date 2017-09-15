# Define SSH key pair for our instances
resource "aws_key_pair" "default" {
  key_name = "vpctestkeypair"
  public_key = "${file("${var.key_path}")}"
}

data "template_file" "user_data" {
  template = "${file("user_data.tpl")}"
}

# Define the Boot Node
resource "aws_instance" "prd-ge-boot" {
   ami  = "${var.ami}"
   instance_type = "c3.large"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sgboot.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   private_ip = "10.0.2.1"
   user_data = "${replace(data.template_file.user_data.rendered, "%%HOSTNAME%%", "prd-ge-boot")}"
   #user_data = "${file("scripts/install.sh")}"

  tags {
    Name = "prd-ge-boot.ie.p16n.org"
  }
}
