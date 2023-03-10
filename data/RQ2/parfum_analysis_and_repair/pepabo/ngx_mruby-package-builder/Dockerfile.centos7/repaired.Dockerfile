FROM centos:7
ARG NGINX_VERSION=
ARG NGX_MRUBY_VERSION=

RUN yum -y install --enablerepo=extras epel-release && rm -rf /var/cache/yum
RUN yum -y groupinstall "Development Tools"
RUN yum -y install rake openssl-devel wget && rm -rf /var/cache/yum
RUN yum -y install rpm-build rpmdevtools yum-utils mercurial which && rm -rf /var/cache/yum

RUN wget https://nginx.org/packages/mainline/centos/7/SRPMS/nginx-$NGINX_VERSION-1.el7.ngx.src.rpm -P /tmp
RUN rpm -Uvh /tmp/nginx-$NGINX_VERSION-1.el7.ngx.src.rpm
RUN yum-builddep -y /tmp/nginx-$NGINX_VERSION-1.el7.ngx.src.rpm

WORKDIR /root/rpmbuild/SPECS
ADD ngx_mruby/centos/nginx.spec.patch /root/rpmbuild/SPECS/nginx.spec.patch
RUN patch -p0 < nginx.spec.patch

WORKDIR /usr/local/src
RUN git clone --branch v$NGX_MRUBY_VERSION --depth 1 https://github.com/matsumotory/ngx_mruby.git

# RUN yum -y update

WORKDIR /usr/local/src/ngx_mruby
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-ngx-src-root=/root/rpmbuild/BUILD/nginx-$NGINX_VERSION
ADD ngx_mruby/build_config.rb /usr/local/src/ngx_mruby/build_config.rb
RUN make build_mruby
RUN make generate_gems_config

RUN rpmbuild -ba /root/rpmbuild/SPECS/nginx.spec
