terraform {
  required_version = ">= 1.0"
  required_providers {
    elestio = {
      source  = "elestio/elestio"
      version = ">= 0.17.0"
    }

    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}
