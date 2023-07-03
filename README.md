### install packer
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install packer

packer -v

### check settings
yc config list

### creat service account
SVC_ACCT="packman"
FOLDER_ID="xxxxxxxxxxxxxxxxx"
yc iam service-account create --name $SVC_ACCT --folder-id $FOLDER_ID

ACCT_ID=$(yc iam service-account get $SVC_ACCT | \
grep ^id | \
awk '{print $2}')

### assign role
yc resource-manager folder add-access-binding --id $FOLDER_ID \
--role editor \
--service-account-id $ACCT_ID

### create IAM key file
yc iam key create --service-account-id $ACCT_ID --output ~/.ssh/yc_key.json

### create ./packer/config.pkr.hcl file:
packer {
  required_plugins {
    yandex = {
      version = ">= 1.1.2"
      source  = "github.com/hashicorp/yandex"
    }
  }
}
cd packer
packer init .
Installed plugin github.com/hashicorp/yandex v1.1.2 in "/home/groot/.config/packer/plugins/github.com/hashicorp/yandex/packer-plugin-yandex_v1.1.2_x5.0_linux_amd64"

packer plugins installed

### validate and build image
packer validate ubuntu16.json
packer build ubuntu16.json

yandex: output will be in this color.

==> yandex: Creating temporary RSA SSH key for instance...
==> yandex: Using as source image: fd8kpp2b3tiom6t9np8a (name: "ubuntu-16-04-lts-v20230626", family: "ubuntu-1604-lts")
==> yandex: Creating network...
==> yandex: Creating subnet in zone "ru-central1-a"...
==> yandex: Creating disk...
==> yandex: Creating instance...
.......................
==> Wait completed after 4 minutes 41 seconds

==> Builds finished. The artifacts of successful builds are:
--> yandex: A disk image was created: reddit-base-1688122833 (id: fd8qub985a0nea3fsc9s) with family name reddit-base

### create an instance from the image
yc compute instance create \
  --name=packman \
  --zone=ru-central1-a \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --create-boot-disk image-id=fd8qub985a0nea3fsc9s \
  --ssh-key ~/.ssh/tumblebuns.pub

### output
done (1m19s)
id: xxxxxxxxxxxxxxxx
folder_id: xxxxxxxxxxxxxxxxx
created_at: "2023-06-30T11:17:19Z"
name: packman
zone_id: ru-central1-a
platform_id: standard-v2
resources:
  memory: "2147483648"
  cores: "2"
  core_fraction: "100"
status: RUNNING
metadata_options:
  gce_http_endpoint: ENABLED
  aws_v1_http_endpoint: ENABLED
  gce_http_token: ENABLED
  aws_v1_http_token: DISABLED
boot_disk:
  mode: READ_WRITE
  device_name: fhm6i7jc5ncd7u4di90m
  auto_delete: true
  disk_id: fhm6i7jc5ncd7u4di90m
network_interfaces:
  - index: "0"
    mac_address: d0:0d:16:59:82:ba
    subnet_id: e9b2kdhg3sqiuc4os6ci
    primary_v4_address:
      address: 10.128.0.6
      one_to_one_nat:
        address: 158.160.107.108
        ip_version: IPV4
gpu_settings: {}
fqdn: fhmmb61bkjbont2o8r1o.auto.internal
scheduling_policy: {}
network_settings:
  type: STANDARD
placement_policy: {}

### checking
% ssh -i ~/.ssh/tumblebuns yc-user@158.160.107.108
Welcome to Ubuntu 16.04.7 LTS (GNU/Linux 4.4.0-142-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

yc-user@fhmmb61bkjbont2o8r1o:~$ hostname
fhmmb61bkjbont2o8r1o

### install reddit app
sudo apt-get update
sudo apt-get install -y git
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d
................
yc-user@fhmmb61bkjbont2o8r1o:~/reddit$ puma -d
Puma starting in single mode...
* Version 3.10.0 (ruby 2.3.1-p112), codename: Russell's Teapot
* Min threads: 0, max threads: 16
* Environment: development
* Daemonizing...

### to build with variables.json
packer build -var-file=variables.json ubuntu16.json

==> Wait completed after 5 minutes 4 seconds

==> Builds finished. The artifacts of successful builds are:
--> yandex: A disk image was created: reddit-base-1688133309 (id: fd8k3leo3vtq6v9gvrit) with family name reddit-base

### to build with variables.json immutable.json
packer build -var-file=variables.json immutable.json

==> Builds finished. The artifacts of successful builds are:
--> yandex: A disk image was created: reddit-full-1688178526 (id: fd83lip89c49tefrg378) with family name reddit-full

### to create an instance - copy image id from output to create-reddit-vm.sh, then run it:
cd ../config-scripts/
./create-reddit-vm.sh

### output
./create-reddit-vm.sh
done (1m6s)
id: fhmn4pjgo22drh1t13a4
folder_id: b1gjev1g87fgira75vkt
created_at: "2023-06-30T15:46:21Z"
name: groot
zone_id: ru-central1-a
platform_id: standard-v2
resources:
  memory: "2147483648"
  cores: "2"
  core_fraction: "100"
status: RUNNING
metadata_options:
  gce_http_endpoint: ENABLED
  aws_v1_http_endpoint: ENABLED
  gce_http_token: ENABLED
  aws_v1_http_token: DISABLED
boot_disk:
  mode: READ_WRITE
  device_name: fhm8of68e2uetstamfo5
  auto_delete: true
  disk_id: fhm8of68e2uetstamfo5
network_interfaces:
  - index: "0"
    mac_address: d0:0d:17:26:67:0c
    subnet_id: e9b2kdhg3sqiuc4os6ci
    primary_v4_address:
      address: 10.128.0.3
      one_to_one_nat:
        address: 51.250.91.143
        ip_version: IPV4
gpu_settings: {}
fqdn: fhmn4pjgo22drh1t13a4.auto.internal
scheduling_policy: {}
network_settings:
  type: STANDARD
placement_policy: {}

### should be working, but it isn't
./create-reddit-vm.sh: line 12: --metadata=startup-script:sudo su -c "puma -d": command not found
