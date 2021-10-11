#General config
region                = "eu-west-1"
terraform-bucket-name = "terraform-state-teamcity-test-task"
#VPC config
vpc_name        = "teamcity-multi-tenant"
cidr            = "10.0.0.0/20"
public_subnets  = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.4.0/22", "10.0.8.0/22", "10.0.12.0/22"]
route53_zones = {
  "teamcity-anton-cloud.com" = {
    comment = "the main zone. all records here created using external-dns"
  }
}
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDL+gt29RS562VGoZBbiX0KrmwqEeUSn5221XypptFWBZ2bS4w49EzFKouE5GFy3ei+DyLslmDYx0m1uBNWYoFiEpKrV1dtR7t51x3Bk7A+XB0j2u5ifG8cDm+0nRVz5WKiFMNaLBEf0FMwqydDFnSl6Q8Fo533VNE9UwpG/LshumvLi4euE5ft3mCbI25mfOth4pqgFR0Fvu+bRN7eM45XkZ3/0krpsjui1ky6qRfV+BJzgX9y1U3eXwksseoUvHyGd06ERhuUqOBtuEf3Jv5XJfp+Zj8Ysoh6gE3tXpnmqyppzPG6K+iTQ8OBTrF/Z9sR9yZXJ4zvY79EsTv1knyoNAn6hJM8mm0G47+9yCj8hbEAXKDAr/3f/n7pBCYvoq2TAcgTgs6O/uNWiiF6Iba9+9KsSsUmHceLJ2aScN3Pq5xse0uCCxi2KqCy0f90s8/+osjQcpik/kh8fk8J6sh8fEKjMuPOOQS0l4iLSAKUueIEZpSwJxERAfM8fwQvP+c= anton.aleksandrov@nike.com"
