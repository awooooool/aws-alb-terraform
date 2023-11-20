// TODO: Subnet CIDR
locals {
  cidr_public  = [for cidr in range(var.Total-AZ) : cidrsubnet("10.0.0.0/16", 8, 0 + cidr)]
  cidr_private = [for cidr in range(var.Total-AZ) : cidrsubnet("10.0.0.0/16", 8, 128 + cidr)]
}

resource "aws_subnet" "Public" {
  count             = var.Total-AZ
  vpc_id            = aws_vpc.Main.id
  cidr_block        = local.cidr_public[count.index]
  availability_zone = data.aws_availability_zones.Subnets-AZ.names[count.index]
}

resource "aws_subnet" "Private" {
  count             = var.Total-AZ
  vpc_id            = aws_vpc.Main.id
  cidr_block        = local.cidr_private[count.index]
  availability_zone = data.aws_availability_zones.Subnets-AZ.names[count.index]
}
