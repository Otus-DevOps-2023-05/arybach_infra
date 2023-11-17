variable "cloud_id" {
  description = "Cloud"
}

variable "folder_id" {
  description = "Folder"
}

variable "zone" {
  description = "Zone"
  # Значение по умолчанию
  default = "ru-central1-a"
}

variable "yc_token" {
  description = "YC token"
}

variable "service_account_key_file" {
  description = "key .json"
}
