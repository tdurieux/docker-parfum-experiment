FROM centos

RUN rpm -i https://pkgs.dyn.su/el8/base/x86_64/cl-asdf-20101028-18.el8.noarch.rpm
RUN rpm -i https://pkgs.dyn.su/el8/base/x86_64/common-lisp-controller-7.4-20.el8.noarch.rpm
RUN rpm -i https://pkgs.dyn.su/el8/base/x86_64/sbcl-2.0.1-4.el8.x86_64.rpm

RUN yum -y install wget && rm -rf /var/cache/yum
RUN yum -y install gcc-c++ && rm -rf /var/cache/yum
RUN yum -y install make && rm -rf /var/cache/yum
RUN yum -y install ncurses-devel && rm -rf /var/cache/yum
RUN wget -c ftp://ftp.freetds.org/pub/freetds/stable/freetds-1.2.18.tar.gz
RUN tar -zxvf freetds-1.2.18.tar.gz && rm freetds-1.2.18.tar.gz
WORKDIR freetds-1.2.18
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/ --with-tdsver=7.4 --enable-msdblib && make && make install
WORKDIR /

RUN yum install -y git && rm -rf /var/cache/yum
RUN git clone https://github.com/dimitri/pgloader.git
WORKDIR pgloader

#bootstrap-centos7.sh
RUN yum -y install yum-utils rpmdevtools @"Development Tools" sqlite-devel zlib-devel && rm -rf /var/cache/yum
# Enable epel for sbcl
RUN yum -y install epel-release && rm -rf /var/cache/yum
RUN yum -y install sbcl && rm -rf /var/cache/yum
# Missing dependency
# ln -s /usr/lib64/libsybdb.so.5 /usr/lib64/libsybdb.so
# prepare the rpmbuild setup
RUN rpmdev-setuptree

RUN make

COPY ./freetds.conf /usr/etc/freetds.conf
COPY ./freetds.conf /etc/freetds.conf
COPY ./freetds.conf /etc/freetds/freetds.conf
COPY ./freetds.conf /freetds-1.2.18/freetds.conf

WORKDIR /pgloader/build/bin/

# TDSVER=7.4 tsql -H global -p 1433 -U ulearn
# build/bin/pgloader -v

COPY ./files/ /pgloader/build/bin/

# ./pgloader commands