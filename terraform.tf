terraform {
  cloud {
    organization = "f5networks-bd"
    workspaces {
      name = "bigip-ingress-opa"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.10.0"
    }
  }

  required_version = "~> 1.3.0"
}
