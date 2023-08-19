resource "aws_instance" "ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id              = var.subnet_id

   root_block_device {
    volume_size = var.volume_size_1
    volume_type = "gp3"
  }

  ebs_block_device {
    device_name = var.volume_name_2 
    volume_size = var.volume_size_2
    volume_type = "gp3"
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_devices != null ? var.ebs_block_devices : []
    content {
      device_name = ebs_block_device.value["device_name"]
      volume_size = ebs_block_device.value["volume_size"]
      volume_type = ebs_block_device.value["volume_type"]
      iops        = ebs_block_device.value["iops"]
    }
  }

  tags = var.tags
}
