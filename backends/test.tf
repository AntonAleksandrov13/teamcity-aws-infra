terraform {
  backend "s3" {
    bucket         = "terraform-state-teamcity-test-task-eu-west-1"
    key            = "terraform"
    region         = "eu-west-1"
    dynamodb_table = "terraform-lock-eu-west-1"
    encrypt        = true
  }
}
