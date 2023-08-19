/**
# Virtual Private Cloud (VPC) Configuration
module "spoke1-vpc" {
  source = "./modules/aws-vpc"

  vpc_cidr_block = "10.51.0.0/16"
  cidr_block = {
    subnet1 = "10.51.1.0/24"
    subnet2 = "10.51.2.0/24"
    subnet3 = "10.51.3.0/24"
    subnet4 = "10.51.4.0/24"
  }

  availability_zones = {
    subnet1 = "us-east-1a"
    subnet2 = "us-east-1a"
    subnet3 = "us-east-1c"
    subnet4 = "us-east-1c"
  }
  
  tags = {
    vpc = {
      Environment = "HHSC-TIERS-PROD"
    }
    subnet1 = {
      Environment = "HHSC-TIERS-PROD"
      Application = "PROD-PRIVATE-BATCH-A"
    }
    subnet2 = {
      Environment = "HHSC-TIERS-PROD"
      Application = "PROD-PRIVATE-DB-A"
    }
    subnet3 = {
      Environment = "HHSC-TIERS-PROD"
      Application = "PROD-PRIVATE-BATCH-B"
    }
    subnet4 = {
      Environment = "HHSC-TIERS-PROD"
      Application = "PROD-PRIVATE-DB-B"
    }
  }
}

# AWS Security Groups - For Batch Servers
module "sg01" {
source = "./modules/aws-sg"
depends_on = [module.spoke1-vpc]

name_prefix       = "PROD-DB-SG"
vpc_id_1         = module.spoke1-vpc.vpc_id

}

# AWS Security Groups - For CDB 1 2 3 Servers
module "sg02" {
source = "./modules/aws-sg"
depends_on = [module.spoke1-vpc]

name_prefix       = "PROD-BATCH-SG"
vpc_id_1          = module.spoke1-vpc.vpc_id

}


# CDB1 
module "ec2_01" {
  source = "./modules/aws-ec2"

  ami_id                = "ami-08a52ddb321b32a8c"  # Replace with the desired AMI ID for RHEL 8.6
  instance_type         = "t2.2xlarge"  # Replace with the desired instance type

  vpc_security_group_ids = [module.sg02.security_group_id]
  subnet_id              = element(module.spoke1-vpc.subnet_order[*].id, 1)

  # OS Drive
  volume_size_1          = "8"

  # Additional Disk #1 
  volume_name_2          = "/dev/sdb"
  volume_size_2          = "100"
          
  ebs_block_devices = [
    {
      device_name = "/dev/sdc"
      volume_size = 100
      volume_type = "io2"
      iops        = 100
    },
    {
      device_name = "/dev/sdd"
      volume_size = 100
      volume_type = "io2"
      iops        = 100
    },
    {
      device_name = "/dev/sde"
      volume_size = 100
      volume_type = "io2"
      iops        = 100
    },
    {
      device_name = "/dev/sdf"
      volume_size = 100
      volume_type = "io2"
      iops        = 100
    },
    {
      device_name = "/dev/sdg"
      volume_size = 100
      volume_type = "io2"
      iops        = 100
    },
    {
      device_name = "/dev/sdh"
      volume_size = 100
      volume_type = "io2"
      iops        = 100
    },
    {
      device_name = "/dev/sdi"
      volume_size = 100
      volume_type = "io2"
      iops        = 100
    },
    {
      device_name = "/dev/sdj"
      volume_size = 100
      volume_type = "io2"
      iops        = 100
    },
    {
      device_name = "/dev/sdk"
      volume_size = 100
      volume_type = "io2"
      iops        = 100
    },
  ]

    tags = {
    Name        = "My EC2 Instance"
    Environment = "Production"
    Application = "Web Server"
    # Add more tags as needed
  }
}

# CDB2
module "ec2_02" {
  source = "./modules/aws-ec2"

  ami_id                = "ami-08a52ddb321b32a8c"  # Replace with the desired AMI ID for RHEL 8.6
  instance_type         = "t2.2xlarge"  # Replace with the desired instance type

  vpc_security_group_ids = [module.sg02.security_group_id]
  subnet_id              = element(module.spoke1-vpc.subnet_order[*].id, 1)

  # OS Drive
  volume_size_1          = "8"

  # Additional Disk #1 
  volume_name_2          = "/dev/sdb"
  volume_size_2          = "100"
          
  ebs_block_devices = [
    {
      device_name = "/dev/sdc"
      volume_size = 100
      volume_type = "io2"
      iops        = 100
    },
    {
      device_name = "/dev/sdd"
      volume_size = 100
      volume_type = "io2"
      iops        = 100
    },
    {
      device_name = "/dev/sde"
      volume_size = 100
      volume_type = "io2"
      iops        = 100
    },
    {
      device_name = "/dev/sdf"
      volume_size = 100
      volume_type = "io2"
      iops        = 100
    },
    {
      device_name = "/dev/sdg"
      volume_size = 100
      volume_type = "io2"
      iops        = 100
    },
    {
      device_name = "/dev/sdh"
      volume_size = 100
      volume_type = "io2"
      iops        = 100
    },
    {
      device_name = "/dev/sdi"
      volume_size = 100
      volume_type = "io2"
      iops        = 100
    },
    {
      device_name = "/dev/sdj"
      volume_size = 100
      volume_type = "io2"
      iops        = 100
    },
    
  ]

    tags = {
    Name        = "My EC2 Instance"
    Environment = "Production"
    Application = "Web Server"
    # Add more tags as needed
  }

}


# CDB3
module "ec2_03" {
  source = "./modules/aws-ec2"

  ami_id                = "ami-08a52ddb321b32a8c"  # Replace with the desired AMI ID for RHEL 8.6
  instance_type         = "t2.2xlarge"  # Replace with the desired instance type

  vpc_security_group_ids = [module.sg02.security_group_id]
  subnet_id              = element(module.spoke1-vpc.subnet_order[*].id, 1)

  # OS Drive
  volume_size_1          = "8"

  # Additional Disk #1 
  volume_name_2          = "/dev/sdb"
  volume_size_2          = "100"
          
  ebs_block_devices = [
    {
      device_name = "/dev/sdc"
      volume_size = 100
      volume_type = "io2"
      iops        = 100
    },
    {
      device_name = "/dev/sdd"
      volume_size = 100
      volume_type = "io2"
      iops        = 100
    },
    {
      device_name = "/dev/sde"
      volume_size = 100
      volume_type = "io2"
      iops        = 100
    },
    {
      device_name = "/dev/sdf"
      volume_size = 100
      volume_type = "io2"
      iops        = 100
    },
    {
      device_name = "/dev/sdg"
      volume_size = 100
      volume_type = "io2"
      iops        = 100
    },
    {
      device_name = "/dev/sdh"
      volume_size = 100
      volume_type = "io2"
      iops        = 100
    },
    {
      device_name = "/dev/sdi"
      volume_size = 100
      volume_type = "io2"
      iops        = 100
    },
    {
      device_name = "/dev/sdj"
      volume_size = 100
      volume_type = "io2"
      iops        = 100
    },    
  ]

    tags = {
    Name        = "My EC2 Instance"
    Environment = "Production"
    Application = "Web Server"
    POC         = "Yes"
    # Add more tags as needed
  }
}

# Batch Server 1
module "ec2_04" {
  source = "./modules/aws-ec2"

  ami_id                = "ami-08a52ddb321b32a8c"  # Replace with the desired AMI ID for RHEL 8.6
  #We currently do not have sufficient x2iedn.32xlarge capacity in the Availability Zone you requested (us-east-2b)
  instance_type         = "t2.medium"  # Replace with the desired instance type

  vpc_security_group_ids = [module.sg01.security_group_id]
  subnet_id              = element(module.spoke1-vpc.subnet_order[*].id, 0)

  # OS Drive
  volume_size_1          = "8"

  # Additional Disk #1 
  volume_name_2          = "/dev/sdb"
  volume_size_2          = "100"

  tags = {
    Name        = "My EC2 Instance"
    Environment = "Production"
    Application = "Web Server"
    # Add more tags as needed
  }
}
**/
/**
# Batch Server 2
module "ec2_05" {
  source = "./modules/aws-ec2"

  ami_id                = "ami-0c55b159cbfafe1f0"  # Replace with the desired AMI ID for RHEL 8.6
  #We currently do not have sufficient x2iedn.32xlarge capacity in the Availability Zone you requested (us-east-2b)
  instance_type         = "x2iedn.16xlarge"  # Replace with the desired instance type

  vpc_security_group_ids = [module.sg01.security_group_id]
  subnet_id              = element(module.spoke1-vpc.subnet_order[*].id, 2)

  # OS Drive
  volume_size_1          = "8"

  # Additional Disk #1 
  volume_name_2          = "/dev/sdb"
  volume_size_2          = "100"

}
**/