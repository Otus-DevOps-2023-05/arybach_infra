git clone https://github.com/tfutils/tfenv.git ~/.tfenv

### add to ~/.zshrc
export PATH="$HOME/.tfenv/bin:$PATH"
source ~/.zshrc

### downgrade terraform to 0.13.1
tfenv install 0.13.1

### output
Installing Terraform v0.13.1
Downloading release tarball from https://releases.hashicorp.com/terraform/0.13.1/terraform_0.13.1_linux_amd64.zip
###################################################################################################################################################################### 100.0%
Downloading SHA hash file from https://releases.hashicorp.com/terraform/0.13.1/terraform_0.13.1_SHA256SUMS
Not instructed to use Local PGP (/home/groot/.tfenv/use-{gpgv,gnupg}) & No keybase install found, skipping OpenPGP signature verification
Archive:  /tmp/tfenv_download.G5No79/terraform_0.13.1_linux_amd64.zip
  inflating: /home/groot/.tfenv/versions/0.13.1/terraform
Installation of terraform v0.13.1 successful. To make this your default version, run 'tfenv use 0.13.1'

### set 0.13.1 as default
tfenv use 0.13.1

### upgrade files
terraform 0.13upgrade

### in main.tf set:
terraform {
  required_version = "0.13.1"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "> 0.35"
    }
  }
}

### add
provider "yandex" {
  service_account_key_file = "/home/groot/.ssh/yc_key.json"
  cloud_id                = "<идентификатор облака>"
  folder_id               = "<идентификатор каталога>"
  zone                    = "ru-central1-a"
}

[0] % terraform init

Initializing the backend...

Initializing provider plugins...
- Finding yandex-cloud/yandex versions matching "> 0.35.*"...
- Installing yandex-cloud/yandex v0.93.0...
- Installed yandex-cloud/yandex v0.93.0 (self-signed, key ID E40F590B50BB8E40)

### check avaialble images
yc compute image list

###
terraform apply -auto-approve

### output
yandex_compute_instance.app: Creating...
yandex_compute_instance.app: Still creating... [10s elapsed]
yandex_compute_instance.app: Still creating... [20s elapsed]
yandex_compute_instance.app: Still creating... [30s elapsed]
yandex_compute_instance.app: Still creating... [40s elapsed]
yandex_compute_instance.app: Still creating... [50s elapsed]
yandex_compute_instance.app: Still creating... [1m0s elapsed]
yandex_compute_instance.app: Still creating... [1m10s elapsed]
yandex_compute_instance.app: Creation complete after 1m13s [id=fhm9cgeqdkojc122k8b0]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

### check terraform.tfstate for ip addr:
"nat_ip_address": "51.250.65.202"

### or via command:
[0] % terraform show | grep nat_ip_address
        nat_ip_address     = "51.250.65.202"

## trying to ssh - fails
[0] % ssh -i ~/.ssh/tumblebuns yc-user@51.250.65.202
The authenticity of host '51.250.65.202 (51.250.65.202)' can't be established.
ED25519 key fingerprint is SHA256:lOIXGIYbR+qjFTh4ROFsFwZ5fmrx3yFqxYmaHFJC0zM.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '51.250.65.202' (ED25519) to the list of known hosts.
yc-user@51.250.65.202: Permission denied (publickey).

### adding ssh key to terraform resource
metadata = {
        ssh-keys = "ubuntu:${file("~/.ssh/tumblebuns.pub")}"
    }

### trying again
[255] % ssh -i ~/.ssh/tumblebuns ubuntu@158.160.97.223
The authenticity of host '158.160.97.223 (158.160.97.223)' can't be established.
ED25519 key fingerprint is SHA256:vtxiRBWMKDK3G5QsgzzYXcmjFxuaa8/wQiY5UCr3z5U.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '158.160.97.223' (ED25519) to the list of known hosts.
Welcome to Ubuntu 16.04.7 LTS (GNU/Linux 4.4.0-142-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

ubuntu@fhm6bqltvmrte0vs2btc:~$ hostname
fhm6bqltvmrte0vs2btc

### adding outputs.tf
output "external_ip_address_app" {
    value = yandex_compute_instance.app.network_interface.0.nat_ip_address
}

[0] % terraform refresh
yandex_compute_instance.app: Refreshing state... [id=fhm6bqltvmrte0vs2btc]

Outputs:

external_ip_address_app = 158.160.97.223

### taint to destroy and apply
terraform taint yandex_compute_instance.app

### either chown ubuntu:ubuntu or chmod 777 files/*

yandex_compute_instance.app (remote-exec): Puma starting in single mode...
yandex_compute_instance.app (remote-exec): * Version 3.10.0 (ruby 2.3.1-p112), codename: Russell's Teapot
yandex_compute_instance.app (remote-exec): * Min threads: 0, max threads: 16
yandex_compute_instance.app (remote-exec): * Environment: development
yandex_compute_instance.app (remote-exec): * Daemonizing...
yandex_compute_instance.app (remote-exec): Created symlink from /etc/systemd/system/multi-user.target.wants/puma.service to /etc/systemd/system/puma.service.
yandex_compute_instance.app: Creation complete after 2m37s [id=fhmilqs7h4kca9hl2d3r]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_app = 62.84.115.50

### checking
62.84.115.50:9292

### after adding variables.tf and terraform.tfvars
terraform apply -var-file="terraform.tfvars"

terraform fmt

### to debug
TF_LOG=debug terraform apply -var-file="terraform.tfvars" .

### added resource to attach load balancer to a target group and activate it
### it requires var.yc_token (set in terraform.tfvars) for authentication
resource "null_resource" "attach_target_group" {
  triggers = {
    target_group_id    = yandex_lb_target_group.reddit_app_group.id
    load_balancer_id   = yandex_lb_network_load_balancer.reddit_app_lb.id
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

### added app_count variable (default = 1 in variables.tf, app_count = 2 in terraform.tfvars, app_count = 1 in terraform.tfvars.example)
### to spin up multiple reddit app instances on terrafrom apply -var-file="terraform.tfvars":

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_app = [
  "84.201.172.248",
  "51.250.3.124",
]
load_balancer_ip = [
  [
    {
      "address" = "51.250.75.167"
      "ip_version" = "ipv4"
    },
  ],
]
network_load_balancer_id = enpfnmh370isa79vv9f3
reddit_target_group_id = enpn504b190ph13po2rq

### reddit app is avaialble
@ 51.250.75.167:80
@ 84.201.172.248:9292
@ 51.250.3.124:9292

### firewall rules can be used to limit access to load balancer exclusively

### added output of the test run, that fails in github - not sure how to fix this:
cd terraform && terraform init && terraform validate -var-file=terraform.tfvars.example

Initializing the backend...

Initializing provider plugins...
- Using previously-installed yandex-cloud/yandex v0.93.0
- Using previously-installed hashicorp/null v3.2.1

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, we recommend adding version constraints in a required_providers block
in your configuration, with the constraint strings suggested below.

* hashicorp/null: version = "~> 3.2.1"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

Warning: The -var and -var-file flags are not used in validate. Setting them has no effect.

These flags will be removed in a future version of Terraform.

Success! The configuration is valid, but there were some validation warnings as shown above.
