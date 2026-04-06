terraform {
  backend "s3" {
    bucket = "pratham-terraform-state-file-bucket"
    key    = "terraform.tfstate"
    region = "ap-south-1"
    }
}