variable cloud_id {
  description = "Cloud"
}

variable folder_id {
  description = "Folder"
}

variable zone {
  description = "Zone"
  # Значение по умолчанию
  default = "ru-central1-a"
}

variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  # Описание переменной
  description = "Path to the private key used for ssh access"
}

variable image_id {
  description = "Disk image"
}

variable subnet_id {
  description = "Subnet"
}

variable yc_token {
  description = "YC token"
}

variable service_account_key_file {
  description = "key .json"
}

variable app_count {
  description = "Number of reddit app instances"
  default     = 1
}
