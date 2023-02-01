from ubuntu:12.04
maintainer evan hazlett <ejhazlett@gmail.com>
run apt-get update && apt-get install --no-install-recommends -y python-dev wget make g++ libreadline-dev libncurses5-dev && rm -rf /var/lib/apt/lists/*;
run wget https://nodejs.org/dist/v0.10.22/node-v0.10.22.tar.gz -O /tmp/node.tar.gz
run ( cd /tmp && tar zxf node.tar.gz && cd node-* && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; make install) && rm node.tar.gz
run npm install -g hubot coffee-script && npm cache clean --force;
