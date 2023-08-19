variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
}

variable "cidr_block" {
  description = "Map of subnet names to CIDR blocks"
  type        = map(string)
}

variable "availability_zones" {
  description = "Map of subnet names to availability zones"
  type        = map(string)
}

variable "tags" {
  description = "Tags for VPC and subnets"
  type        = map(map(string))
}