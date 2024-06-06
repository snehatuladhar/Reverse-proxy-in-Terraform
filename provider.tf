provider "aws" {
  region = local.region
  default_tags {
    tags = {
      owner     = "sneha"
      silo      = "intern"
      terraform = "true"
    }
  }
}