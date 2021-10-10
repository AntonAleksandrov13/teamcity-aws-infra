variable "region" {
  default = "eu-west-1"
  type    = string
}

variable "terraform-bucket-name" {
  default = "terraform-state-teamcity-test-task"
  type    = string

}

variable "vpc_name" {
  type = string
}

variable "cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}
