ssh -i ~/.ssh/tumblebuns.pub tumblebuns@84.201.132.210

# this doesn’t work
ssh-copy-id -i ~/.ssh/tumblebuns.pub tumblebuns@84.201.132.210

# adding login to remote vm
ssh-add -L
ssh-add ~/.ssh/tumblebuns

# using -A for explicit agent forwarding
ssh -i ~/.ssh/tumblebuns -A tumblebuns@84.201.132.210

# then ssh into a private vm
ssh 10.128.0.13

#output
tumblebuns@fortknox:~$ hostname
fortknox

tumblebuns@fortknox:~$ ip a show eth0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether d0:0d:1f:63:bb:b0 brd ff:ff:ff:ff:ff:ff
    altname enp138s0
    altname ens8
    inet 10.128.0.13/24 metric 100 brd 10.128.0.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::d20d:1fff:fe63:bbb0/64 scope link
       valid_lft forever preferred_lft forever

# there should be no keys on bastion host:
tumblebuns@bastion:~$  ls -la ~/.ssh/
total 20
drwx------ 2 tumblebuns tumblebuns 4096 Jun 23 05:24 .
drwxr-x--- 4 tumblebuns tumblebuns 4096 Jun 23 05:20 ..
-rw------- 1 tumblebuns tumblebuns  566 Jun 23 04:35 authorized_keys
-rw------- 1 tumblebuns tumblebuns  978 Jun 23 05:24 known_hosts
-rw-r--r-- 1 tumblebuns tumblebuns  142 Jun 23 05:18 known_hosts.old

# single line ssh connection to remote private vm
This command establishes an SSH connection to fortknox by first connecting to the bastion host (84.201.132.210) as the tumblebuns user, and then jumping from the bastion host to fortknox (10.128.0.13) as the tumblebuns user. The -A option enables agent forwarding, allowing you to use your local SSH key on the remote machine.

% ssh -i ~/.ssh/tumblebuns -A -J tumblebuns@84.201.132.210 tumblebuns@10.128.0.13

The authenticity of host '10.128.0.13 (<no hostip for proxy command>)' can't be established.
ED25519 key fingerprint is SHA256:Hfglx/VFkQBUOe/FvYFGbEH3+dNss92dCAtzGeehFjs.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.128.0.13' (ED25519) to the list of known hosts.
…

  System information as of Fri Jun 23 05:32:55 AM UTC 2023

  System load:  0.046875           Processes:             130
  Usage of /:   24.2% of 17.63GB   Users logged in:       0
  Memory usage: 22%                IPv4 address for eth0: 10.128.0.13
  Swap usage:   0%

Expanded Security Maintenance for Applications is not enabled.

Last login: Fri Jun 23 05:27:33 2023 from 10.128.0.27
tumblebuns@fortknox:~$ hostname
fortknox



# using aliases to shorten the command – add to ~/.zshrc:
alias fortknox="ssh -i ~/.ssh/tumblebuns -A -J tumblebuns@84.201.132.210 tumblebuns@10.128.0.13"

source ~/.zshrc

# then use alias name without
fortknox

[0] % fortknox
Welcome to Ubuntu 22.04.2 LTS (GNU/Linux 5.15.0-75-generic x86_64)
...
  System information as of Fri Jun 23 06:15:28 AM UTC 2023

  System load:  0.0                Processes:             130
  Usage of /:   24.2% of 17.63GB   Users logged in:       0
  Memory usage: 22%                IPv4 address for eth0: 10.128.0.13
  Swap usage:   0%
...
Last login: Fri Jun 23 06:14:08 2023 from 10.128.0.27

tumblebuns@fortknox:~$ hostname
fortknox

# or we can use a function to ~/.zshrc

function fortknox() {
    ssh -i ~/.ssh/tumblebuns -A -J tumblebuns@84.201.132.210 tumblebuns@10.128.0.13 "$@"
}

#source
source ~/.zshrc
fortknox

# to make fortknox alias callable with ssh create new alias for “ssh “:
alias ssh='ssh '
source ~/.zshrc
# then ssh fortknox command should work
ssh fortknox


# to setup VPN server Pritunl
https://techviewleo.com/install-pritunl-vpn-on-ubuntu-server/

sudo apt update && sudo apt upgrade -y
sudo apt install wget vim curl gnupg2 software-properties-common apt-transport-https ca-certificates lsb-release

sudo tee /etc/apt/sources.list.d/pritunl.list << EOF deb https://repo.pritunl.com/stable/apt jammy main EOF

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A

echo "deb http://security.ubuntu.com/ubuntu focal-security main" | sudo tee /etc/apt/sources.list.d/focal-security.list sudo apt update sudo apt install libssl1.1

wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

sudo apt update && sudo apt install pritunl mongodb-org

sudo systemctl start pritunl mongod
sudo systemctl enable pritunl mongod

sudo systemctl status pritunl

http://ip-addr/setup

sudo pritunl setup-key
sudo pritunl default-password

set password for default user:
pritunl
pritunlme

Далее добавляем в веб интерфейсе на вкладке Users: Организацию Пользователя test с PIN 6214157507237678334670591556762 На вкладке Servers добавляем сервер, привязываем его к организации и запускаем. Подробнее: https://docs.pritunl.com/v1/docs/connecting


on a local machine:
sudo apt install openvpn
then move config file downloaded from the pritunl dashboard (down arrow) to /etc/openvpn/congif.ovpn
tar -xf ~/Downloads test.tar
sudo mv test_test_pritunl.ovpn /etc/openvpn/config.ovpn
sudo openvpn --config /etc/openvpn/config.ovpn

use for authentication:
test
6214157507237678334670591556762


# add certbot and install nip.io (for ip address)

sudo systemctl stop pritunl

sudo apt install certbot
sudo apt update
sudo apt install -y curl jq

PUBLIC_IP=$(curl -s https://api.ipify.org)
echo $PUBLIC_IP

sudo curl -LO https://github.com/exentrique/nip.io/raw/master/bin/nip.io
chmod +x nip.io
sudo mv nip.io /usr/local/bin/

sudo nano /etc/systemd/system/nip.io.service

# paste this into the file
[Unit]
Description=Update Nip.io DNS record
After=network-online.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c "curl -sSL https://api.ipify.org | xargs -I {} nip.io update {}"

[Install]
WantedBy=multi-user.target

# enable nip.io service
sudo systemctl enable nip.io
sudo systemctl start nip.io

# run certbot on <madeupdomain>.<youripaddress>.nip.io

sudo certbot certonly --standalone --preferred-challenges http -d tumblebuns.84.201.132.210.nip.io

sudo find / -name "pritunl.conf" -type f 2>/dev/null
>> /etc/pritunl.conf
sudo nano /etc/pritunl.conf

sudo chown -R pritunl:pritunl /etc/letsencrypt/live/tumblebuns.84.201.132.210.nip.io

# add these lines
/etc/letsencrypt/live/tumblebuns.84.201.132.210.nip.io/fullchain.pem
/etc/letsencrypt/live/tumblebuns.84.201.132.210.nip.io/privkey.pem

as follows:
{
    "static_cache": true,
    "port": 443,
    "temp_path": "/tmp/pritunl_9d5178c999ee45e9a777758b01ed3f30",
    "log_path": "/var/log/pritunl.log",
    "www_path": "/usr/share/pritunl/www",
    "bind_addr": "0.0.0.0",
    "mongodb_uri": "mongodb://localhost:27017/pritunl",
    "local_address_interface": "auto",
    "server_ssl_cert": "/etc/letsencrypt/live/tumblebuns.84.201.132.210.nip.io/fullchain.pem",
    "server_ssl_key": "/etc/letsencrypt/live/tumblebuns.84.201.132.210.nip.io/privkey.pem"
}

# then
sudo systemctl restart pritunl

# should be working, but it’s not:
sudo systemctl status nip.io
Job for nip.io.service failed because the control process exited with error code.
See "systemctl status nip.io.service" and "journalctl -xeu nip.io.service" for details.
× nip.io.service - Update Nip.io DNS record
     Loaded: loaded (/etc/systemd/system/nip.io.service; enabled; vendor preset: enabled)
     Active: failed (Result: exit-code) since Fri 2023-06-23 15:43:44 UTC; 16ms ago
    Process: 3967 ExecStart=/bin/bash -c curl -sSL https://api.ipify.org | xargs -I {} nip.io update {} (code=e>
   Main PID: 3967 (code=exited, status=123)
        CPU: 95ms

Jun 23 15:43:40 bastion systemd[1]: Starting Update Nip.io DNS record...
Jun 23 15:43:44 bastion bash[3975]: /usr/local/bin/nip.io: 1: 404:: not found
Jun 23 15:43:44 bastion systemd[1]: nip.io.service: Main process exited, code=exited, status=123/n/a
Jun 23 15:43:44 bastion systemd[1]: nip.io.service: Failed with result 'exit-code'.
Jun 23 15:43:44 bastion systemd[1]: Failed to start Update Nip.io DNS record.

# trying

sudo /usr/local/bin/nip.io update 84.201.132.210
# get
/usr/local/bin/nip.io: 1: 404:: not found

# don’t know hos to fix this
