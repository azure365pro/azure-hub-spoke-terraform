resource "aws_security_group" "sg" {
  name_prefix = var.name_prefix
  vpc_id      = var.vpc_id_1
}

