resource "aws_autoscaling_group" "this" {
  name                 = "${var.name}-asg"
  max_size             = var.max_size
  min_size             = var.min_size
  desired_capacity     = var.desired_capacity
  vpc_zone_identifier  = var.subnet_ids
  target_group_arns    = var.target_group_arns
  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }
  health_check_type         = "EC2"
  health_check_grace_period = 300
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "${var.name}-instance"
    propagate_at_launch = true
  }
}
