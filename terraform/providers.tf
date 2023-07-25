terraform {
  required_version = ">= 0.13.1"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.93.0"
      # version = "> 0.35"
    }
  }
}
