# Create a target group for the Reddit app instances
resource "yandex_lb_target_group" "reddit_app_group" {
  name      = "reddit-group"
  region_id = "ru-central1"
  folder_id = var.folder_id

  dynamic "target" {
    for_each = yandex_compute_instance.app
    content {
      subnet_id = var.subnet_id
      address   = target.value.network_interface.0.ip_address
    }
  }
}

# Attach the target group to the network load balancer using the http provider
resource "null_resource" "attach_target_group" {
  triggers = {
    target_group_id  = yandex_lb_target_group.reddit_app_group.id
    load_balancer_id = yandex_lb_network_load_balancer.reddit_app_lb.id
  }

  provisioner "local-exec" {
    command = <<EOF
curl --request POST \
  --url https://load-balancer.api.cloud.yandex.net/load-balancer/v1/networkLoadBalancers/${yandex_lb_network_load_balancer.reddit_app_lb.id}:addTargetGroup \
  --header 'Authorization: Bearer ${var.yc_token}' \
  --header 'Content-Type: application/json' \
  --data '{
    "targetGroupId": "${yandex_lb_target_group.reddit_app_group.id}"
  }'
EOF
  }

  depends_on = [yandex_lb_target_group.reddit_app_group, yandex_lb_network_load_balancer.reddit_app_lb]
}

# Create a network load balancer for the Reddit app instances
resource "yandex_lb_network_load_balancer" "reddit_app_lb" {
  name      = "reddit-lb"
  region_id = "ru-central1"
  folder_id = var.folder_id

  listener {
    name        = "http-listener"
    port        = 80
    target_port = 9292
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.reddit_app_group.id
    healthcheck {
      name = "reddit-healthcheck"
      http_options {
        path = "/"
        port = 9292
      }
    }
  }
}
