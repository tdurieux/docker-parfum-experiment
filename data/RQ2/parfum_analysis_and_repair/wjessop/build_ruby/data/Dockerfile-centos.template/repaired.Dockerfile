FROM {{.Distro}}
RUN yum update -y
RUN yum install -y gcc gcc-c++ make automake kernel-devel rpm-build \
    glibc-devel libffi-devel gdbm-devel ncurses-devel \
    readline-devel openssl-devel libyaml-devel zlib-devel \
    curl tar && rm -rf /var/cache/yum
# Install a more modern version of Ruby. A dep of fpm got updated and isn't
# compatible with ruby 1.8.7 which is what is installed via yum
ADD https://sendcat.com/dl/BadJLd0pAxQ1JVCJ4jLCtf5MrF8E3A9bn2vKSmanZfOt1DQQ91zjCgw/1651/ruby-2.3.0_37s~centos_amd64.rpm /tmp/
RUN rpm -i /tmp/ruby-2.3.0_37s~centos_amd64.rpm
RUN ["/opt/ruby2.3.0/bin/gem", "install", "fpm", "--bindir=/usr/bin", "--no-rdoc", "--no-ri"]
RUN curl -f {{.DownloadUrl}} | tar oxzC /tmp
{{range .Patches}}ADD {{.}} /
{{end}}
WORKDIR /tmp/ruby-{{.RubyVersion}}
RUN for i in `/bin/ls /*.patch`; do patch -p0 < $i; done
RUN CFLAGS='-march=x86-64 -O3 -fno-fast-math -g3 -ggdb -Wall -Wextra -Wno-unused-parameter -Wno-parentheses -Wno-long-long -Wno-missing-field-initializers -Wunused-variable -Wpointer-arith -Wwrite-strings -Wdeclaration-after-statement -Wimplicit-function-declaration -Wdeprecated-declarations -Wno-packed-bitfield-compat -std=iso9899:1999  -fPIC' ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  --prefix=/usr/local \
  --enable-shared \
  --disable-install-doc \
  --enable-load-relative
# Seems to only affect some 1.9 series Rubies, but the combined make step:
#
#     RUN make -j8 install DESTDIR=/tmp/fpm
#
# that ran the make then make install, was broken. Splitting it up into
# two separate commands works fine:
RUN make -j{{.NumCPU}}
RUN make install DESTDIR=/tmp/fpm

WORKDIR /
RUN fpm \
    -s dir \
    -t rpm \
    -n ruby \
    -a {{.Arch}} \
    -v {{.RubyVersion}} \
    {{.Iteration}}
    -d glibc-devel \
    -d libffi-devel \
    -d gdbm-devel \
    -d ncurses-devel \
    -d readline-devel \
    -d openssl-devel \
    -d libyaml-devel \
    -d zlib-devel \
    -C /tmp/fpm \
    -p /{{.FileName}} \
    usr
