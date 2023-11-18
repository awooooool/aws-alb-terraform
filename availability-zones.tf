data "aws_regions" "Regions" {}

data "aws_availability_zones" "Subnets-AZ" {
  state = "available"
}

variable "Region" {
  type     = string
  nullable = false
}

output "regions" {
  value = data.aws_regions.Regions
}

# To validate region variable against list of available regions
# Using this method since regular validate doesn't work somehow
# See https://github.com/hashicorp/terraform/issues/25609#issuecomment-1057614400
locals {
  validate_region = contains(data.aws_regions.Regions.names, var.Region) ? true : tobool("Invalid region")
}
