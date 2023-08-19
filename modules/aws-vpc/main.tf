resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags       = var.tags["vpc"]
}

resource "aws_subnet" "subnet" {
  for_each          = var.cidr_block
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value
  availability_zone = var.availability_zones[each.key]

  tags = merge(
    var.tags["vpc"],
    var.tags[each.key]
  )
}