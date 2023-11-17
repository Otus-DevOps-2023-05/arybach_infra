terraform {
  required_version = ">= 0.13.1"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.93.0"
    }
  }
}

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

# this module is applied first to fetch sg_id for app and db modules (it doesn't work with outputs and variables)
# module "vpc" {
#   source = "../modules/vpc"

#   providers = {
#     yandex = yandex
#   }

# }

module "app" {
  source          = "../modules/app"
  public_key_path = var.public_key_path
  app_disk_image  = var.app_disk_image
  subnet_id       = var.subnet_id
  security_group_id = module.vpc.reddit_sg_id

  providers = {
    yandex = yandex
  }
}

module "db" {
  source          = "../modules/db"
  public_key_path = var.public_key_path
  db_disk_image   = var.db_disk_image
  subnet_id       = var.subnet_id
  security_group_id = module.vpc.reddit_sg_id

  providers = {
    yandex = yandex
  }
}
