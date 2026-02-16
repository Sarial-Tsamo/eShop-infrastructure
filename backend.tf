terraform {
 
    backend "s3" {
        bucket         = "eshop-terraform-state-561724541923"
        key            = "global/terraform.tfstate"
        region         = var.aws_region
        encrypt        = true
        dynamodb_table = "terraform-locks"
    }
}