from ubuntu:12.10
maintainer Justin Gallardo <justin.gallardo@gmail.com>

run echo "deb http://archive.ubuntu.com/ubuntu quantal main universe" > /etc/apt/sources.list
run apt-get update
run apt-get upgrade -y

run apt-get install --no-install-recommends curl wget -y && rm -rf /var/lib/apt/lists/*;
run apt-get install --no-install-recommends supervisor -y && rm -rf /var/lib/apt/lists/*;
run apt-get install --no-install-recommends openssh-server -y && rm -rf /var/lib/apt/lists/*;
run apt-get install --no-install-recommends make build-essential -y && rm -rf /var/lib/apt/lists/*;
run apt-get install --no-install-recommends python python-dev -y && rm -rf /var/lib/apt/lists/*;

run mkdir -p /var/run/sshd
run mkdir -p /var/log/supervisor
run locale-gen en_US en_US.UTF-8

run echo 'root:badpass' | chpasswd


run apt-get install --no-install-recommends git vim -y && rm -rf /var/lib/apt/lists/*;

run curl -f https://raw.github.com/isaacs/nave/master/nave.sh > /bin/nave && chmod a+x /bin/nave
run nave usemain stable

run apt-get install --no-install-recommends redis-server -y && rm -rf /var/lib/apt/lists/*;

run git clone https://github.com/jirwin/treslek.git /opt/treslek
run cd /opt/treslek && npm install && npm cache clean --force;
run apt-get install -y --no-install-recommends figlet && rm -rf /var/lib/apt/lists/*;

add supervisord.conf /etc/supervisor/conf.d/supervisord.conf

add conf.js /opt/treslek/conf.js

cmd ["/usr/bin/supervisord", "-n"]

expose 22 6379
