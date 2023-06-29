testapp_IP = 51.250.91.183
testapp_port = 9292

### to launch an app
./startup.sh

### it kicks off sequentially
./install_ruby.sh
./install_mongodb.sh
./deploy.sh


### alternatively below are manual instructions

### yc init
### yc config
### yc config profile list

### Create new compute instance for reddit-app
yc compute instance create \
 --name reddit-app \
 --hostname reddit-app \
 --memory=4 \
 --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
 --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
 --metadata serial-port-enable=1 \
 --ssh-key ~/.ssh/tumblebuns.pub

sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential


### install mongoDb
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -

echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/m>

sudo apt-get update
sudo apt-get install -y mongodb-org

sudo systemctl start mongod
sudo systemctl enable mongod
sudo systemctl status mongod

### install git
sudo apt install git

### clone app code
git clone -b monolith https://github.com/express42/reddit.git

### install app
cd reddit && bundle install

### launch app
puma -d

### check
ps aux | grep puma
