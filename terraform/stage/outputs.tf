output "external_ip_address_app" {
  value = module.app.external_ip_address_app
}

output "external_ip_address_db" {
  value = module.db.external_ip_address_db
}

# output "external_ip_address_app" {
#   value = [for instance in yandex_compute_instance.app : instance.network_interface.0.nat_ip_address]
# }

# output "network_load_balancer_id" {
#   value = yandex_lb_network_load_balancer.reddit_app_lb.id
# }

# output "reddit_target_group_id" {
#   value = yandex_lb_target_group.reddit_app_group.id
# }

# output "load_balancer_ip" {
#   value = [
#     for listener in yandex_lb_network_load_balancer.reddit_app_lb.listener :
#     listener.external_address_spec
#   ]
# }
