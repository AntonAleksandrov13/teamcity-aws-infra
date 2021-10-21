# teamcity-aws-infra
This repository contains Terraform code which provisions an AWS account specifically for multi-tenant setup of TeamCity.

## prerequisites
Terraform bucket specified in backend dir and aws users to authenticate to AWS and EKS(see aws-auth cm).

## what's inside?
This project consists of two primary components - global infra and tenant infra. In short, global infra ensures that all shared resources are in place before letting tenant in. Since TeamCity will be deployed to EKS we need to provision VPC, IAM, EFS, Route53 and shared Helm applications in advance.

##GLOBAL INFRA
### VPC module
VPC module takes advantage of the official AWS Terraform module and installs a VPC with 6 subnets(3 public and 3 private). In addition, to ensure network connectivity for EKS we deploy NAT gateway and IGW.

### EKS module
To run the workloads we launch EKS of the latest version with OIDC enabled. EKS takes ownership of 3 ASGs spread accross 3 AZs

### IAM module
Creates roles for utility application such as external-dns and route53 to mange AWS resource from within the cluster

### Bastion module
An EC2 instance with SSM agent installed in private subnet(s). It will be used to establish a port-forward to connect MySQL

### Cloudfront module
Creates a shared OAI for Teamcity network optimization and artifact sharing via CloudFront.
### Route53 module
Creates a single hosted zone for Teamcity. It's managed by external-dns from EKS

### Helm module
Probably should have called it applications module. Installs the aforementioned utility applications inside EKS

### EFS module
Create an EFS and mounting targets for EKS to use. Managed by aws-efs-csi-driver. PVC are created by Teamcity chart to persist data overtime.

## TENANT INFRA
## Cloudfront module(again?)
This is tenant-specific module used to create distributions and provision key-pairs which Teamcity can use to create pre-signed urls

## S3 module
A S3 bucker per tenant with enabled read permisions for the mentione OAI, versioned enabled and prefix created in advance

## IAM module
Creates IAM roles for Agent and Server to use. Currently only enables working with S3 bucket

## RDS module
Creates MySQL database and pushes credentials to Helm module to let Teamcity authorize using username and password
## Helm module
The pinnacle of this project - installs Teamcity into a separate namespace with RDS and Cloudfront credentials. Source code: https://github.com/AntonAleksandrov13/teamcity-chart

# how do I install this?
There's a set of scripts included in this project. Please see Github actions runs or workflow yaml files.