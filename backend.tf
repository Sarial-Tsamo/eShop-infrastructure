terraform {
 
    backend "s3" {
        bucket         = "eshop-terraform-state-561724541923"
        key            = "global/terraform.tfstate"
        region         = "eu-central-1"
        encrypt        = true
        dynamodb_table = "terraform-locks"
    }
}