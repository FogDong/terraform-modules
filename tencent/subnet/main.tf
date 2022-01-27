terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
    }
  }
}

variable "availability_zone" {
  description = "Availability Zone"
  default = "ap-beijing-1"
}

resource "tencentcloud_vpc" "foo" {
  name       = "guagua-ci-temp-test"
  cidr_block = "10.0.0.0/16"
}

resource "tencentcloud_subnet" "subnet" {
  availability_zone = var.availability_zone
  name              = var.name
  vpc_id            = tencentcloud_vpc.foo.id
  cidr_block        = var.cidr_block
  is_multicast      = var.is_multicast
}

variable "name" {
  description = "Subnet name"
  default = "guagua-ci-temp-test"
  type = string
}

variable "cidr_block" {
  description = "Subnet CIDR block"
  default = "10.0.20.0/28"
  type = string
}

variable "is_multicast" {
  description = "Subnet is multicast"
  default = false
  type = bool
}

output "SUBNET_ID" {
  value = tencentcloud_subnet.subnet.id
}