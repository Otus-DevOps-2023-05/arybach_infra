resource "yandex_vpc_security_group" "reddit" {
  name        = "reddit-sg"
  description = "Allow inbound HTTP traffic and inter-VPC communication"
  network_id  = yandex_vpc_network.app-network.id

  # Allow traffic on port 80 from anywhere
  ingress {
    protocol       = "TCP"
    from_port      = 80
    to_port        = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow traffic on port 9292 for the app from anywhere
  ingress {
    protocol       = "TCP"
    from_port      = 9292
    to_port        = 9292
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH traffic from anywhere (for now)
  ingress {
    protocol       = "TCP"
    from_port      = 22
    to_port        = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow intra-VPC traffic (for both app and db to communicate)
  # Assuming the VPC CIDR is 10.0.0.0/16, adjust as needed
  ingress {
    protocol       = "TCP"
    from_port      = 0    # This effectively means "all ports"
    to_port        = 65535 # This effectively means "all ports"
    v4_cidr_blocks = ["10.0.0.0/16"]
  }

  # Allow all outbound traffic for TCP
  egress {
    protocol       = "TCP"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic for UDP
  egress {
    protocol       = "UDP"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # If you also need to allow all UDP traffic within the VPC, add:
  ingress {
    protocol       = "UDP"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["10.0.0.0/16"]
  }
}

output "reddit_sg_id" {
  value = yandex_vpc_security_group.reddit.id  # Corrected the reference here
}
