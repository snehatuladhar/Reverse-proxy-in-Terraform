variable "subnets-conf" {
  description = "CIDR for Subnets"
  type = map(object({
    cidr = string
    az   = string
  }))
  default = {
    "public-subnet-1a" = {
      cidr = "10.0.0.0/22"
      az   = "us-east-1a"
    }
    "private-subnet-1a" = {
      cidr = "10.0.4.0/22"
      az   = "us-east-1a"
    }
    "public-subnet-1b" = {
      cidr = "10.0.8.0/22"
      az   = "us-east-1b"
    }
    "private-subnet-1b" = {
      cidr = "10.0.12.0/22"
      az   = "us-east-1b"
    }
  }
}
variable "owner_tag" {
  description = "Values for owner Tags"
  type        = string
  default     = "sneha"
}