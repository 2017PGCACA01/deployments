resource "aws_launch_template" "this" {
  name_prefix   = "ec2-launch-template-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  user_data = base64encode(var.user_data)

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = var.vpc_security_group_ids
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "EC2Instance"
    }
  }
}
