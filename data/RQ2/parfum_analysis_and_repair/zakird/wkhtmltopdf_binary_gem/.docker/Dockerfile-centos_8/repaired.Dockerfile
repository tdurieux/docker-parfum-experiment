FROM centos:8

# https://centos.org/centos-stream/#centos-stream-8
#  Replace mirror
RUN find /etc/yum.repos.d -type f -exec sed -i 's/mirrorlist=http:\/\/mirrorlist.centos.org/\#mirrorlist=http:\/\/mirrorlist.centos.org/g' {} \;
RUN find /etc/yum.repos.d -type f -exec sed -i 's/\#baseurl=http:\/\/mirror.centos.org/baseurl=http:\/\/vault.centos.org/g' {} \;
RUN dnf update -y

#  Swap versions
RUN dnf swap centos-linux-repos centos-stream-repos -y
RUN dnf update -y
RUN dnf install centos-release-stream -y
RUN dnf swap centos-{linux,stream}-repos -y

# Sync
RUN dnf distro-sync -y

RUN yum install -y ruby libjpeg-turbo libpng libXrender fontconfig libXext && rm -rf /var/cache/yum

CMD /root/wkhtmltopdf_binary_gem/bin/wkhtmltopdf --version
