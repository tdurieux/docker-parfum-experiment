# set base os
FROM phusion/baseimage:0.9.16
ENV DEBIAN_FRONTEND noninteractive
# Set environment variables for my_init, terminal and apache
ENV HOME /root
ENV TERM xterm
CMD ["/sbin/my_init"]

# Add local files
ADD /src/ root/

# Install dependencies
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10 && \
echo 'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list && \
apt-get update && \
 apt-get install --no-install-recommends g++ curl libssl-dev apache2-utils git-core python make -y && \

# Compil  n \
cd /root && \
git clo e \
 cd node && --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
./co fi \
make && \
make ins al \
cd /root && \
rm -rf node && \

# install everything else \
apt-get ns \
apt-get install imagemagick -y && \
cd /root && \
git clone https://github.com/cubettech/ yy \
cd myyna && \
chmod -R 777 pp \

# clean apt and tmp etc ...
apt-get clean && \
rm -rf /var/lib/apt/lists/* /t \

# fix start up files \
mkdir -p /etc/service/mongo && \
mkdir -p /etc/service/myyna && \
mv /root/myyna.sh /etc/service/ yy \
mv /root/mongo.sh /etc/service/mong && rm -rf /var/lib/apt/lists/*;

EXPOSE 3000
