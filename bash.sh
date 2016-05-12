# update apt-get source and install required tool set
cp /etc/apt/sources.list /etc/apt/sources.list_bak
rm /etc/apt/sources.list
cp /vagrant/workspace/sources.list /etc/apt
apt-get update
apt-get install -y git xz-utils wget memcached redis-server curl make gcc build-essential python2.7

# setup workspace and create directories for runtime
cd ~
mkdir workspace
cd workspace
mkdir conf
mkdir pid
mkdir log
mkdir bash

# download and install node/npm
wget --tries=100 --retry-connrefused https://nodejs.org/dist/v5.10.1/node-v5.10.1-linux-x64.tar.xz
xz -d node-v5.10.1-linux-x64.tar.xz
tar -xvf node-v5.10.1-linux-x64.tar
rm node-v5.10.1-linux-x64.tar
mv node-v5.10.1-linux-x64 /usr/local/node
chmod 755 /usr/local/node/* -R
sudo ln -s /usr/local/node/bin/node /usr/bin/node
sudo ln -s /usr/local/node/bin/npm /usr/bin/npm

# start up memcached
memcached -d -u root -P /home/workspace/pid/memcached.pid

# start up redis-server with updated configuration
cp /etc/redis/redis.conf /home/workspace/conf
sed -i "s/\/var\/run\/redis\/redis-server.pid/\/home\/workspace\/pid\/redis-server.pid/g" /home/workspace/conf/redis.conf
sed -i "s/\/var\/log\/redis\/redis-server.log/\/home\/workspace\/log\/redis-server.log/g" /home/workspace/conf/redis.conf
redis-server /home/workspace/conf/redis.conf

# setup ENV variables
# echo "export TEST=\"test\"" >> /etc/profile # FIXME
# source /etc/profile

# setup git configurations and clone the repo onto local workspace
git config --global user.name "xxx" # FIXME
git config --global user.email "xxx@xxx.com" # FIXME
git config --global color.ui true
git clone https://xxx:xxx@github.com/xxx/xxx.git # FIXME

# install node packages and startup application
npm config set registry https://registry.npm.taobao.org
# install coffee-script
npm install coffee-script -g
sudo ln -s /usr/local/node/lib/node_modules/coffee-script/bin/coffee /usr/bin/coffee
sudo ln -s /usr/local/node/lib/node_modules/coffee-script/bin/cake /usr/bin/cake
npm config set python python2.7
# npm --registry=https://registry.npm.taobao.org install
