FROM centos:6
ARG NGINX_VERSION=
ARG NGX_MRUBY_VERSION=

RUN yum -y install --enablerepo=extras epel-release
RUN yum -y groupinstall "Development Tools"
RUN yum -y install wget tar openssl-devel
RUN yum -y install rpm-build rpmdevtools yum-utils mercurial perl-ExtUtils-Embed

RUN wget https://s3.amazonaws.com/pkgr-buildpack-ruby/current/centos-6/ruby-2.2.3.tgz
RUN tar xf ruby-2.2.3.tgz -C /usr/local

RUN wget http://nginx.org/packages/mainline/centos/6/SRPMS/nginx-$NGINX_VERSION-1.el6.ngx.src.rpm -P /tmp
RUN rpm -Uvh /tmp/nginx-$NGINX_VERSION-1.el6.ngx.src.rpm
RUN yum-builddep -y --nogpgcheck /tmp/nginx-$NGINX_VERSION-1.el6.ngx.src.rpm

WORKDIR /root/rpmbuild/SPECS
ADD ngx_mruby/centos/nginx.spec.patch /root/rpmbuild/SPECS/nginx.spec.patch
RUN patch -p0 < nginx.spec.patch

WORKDIR /usr/local/src
RUN git clone --depth 1 https://github.com/matsumoto-r/ngx_mruby.git
WORKDIR /usr/local/src/ngx_mruby
RUN git checkout v$NGX_MRUBY_VERSION

RUN yum -y update

WORKDIR /usr/local/src/ngx_mruby
RUN ./configure --with-ngx-src-root=/root/rpmbuild/BUILD/nginx-$NGINX_VERSION
ADD ngx_mruby/build_config.rb /usr/local/src/ngx_mruby/build_config.rb
RUN make build_mruby
RUN make generate_gems_config

RUN rpmbuild -ba /root/rpmbuild/SPECS/nginx.spec
