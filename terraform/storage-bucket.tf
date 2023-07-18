data "yandex_storage_bucket" "existing_bucket" {
  name = "tumblebuns"
}

resource "yandex_storage_bucket" "my_bucket" {
  count  = data.yandex_storage_bucket.existing_bucket ? 0 : 1
  name   = "tumblebuns"
  access = "private"
  lifecycle {
    prevent_destroy = true
  }
}
