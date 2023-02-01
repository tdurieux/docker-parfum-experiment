FROM {{.Distro}}
RUN apt-get update && apt-get install --no-install-recommends -y ruby1.9.3 build-essential \
    libc6-dev libffi-dev libgdbm-dev libncurses5-dev \
    libreadline-dev libssl-dev libyaml-dev zlib1g-dev \
    curl && rm -rf /var/lib/apt/lists/*;
RUN ["/usr/bin/gem", "install", "fpm", "--bindir=/usr/bin", "--no-rdoc", "--no-ri"]
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
    -t deb \
    -n ruby \
    -a {{.Arch}} \
    -v {{.RubyVersion}} \
    {{.Iteration}}
    -d libc6-dev \
    -d libffi-dev \
    -d libgdbm-dev \
    -d libncurses5-dev \
    -d libreadline-dev \
    -d libssl-dev \
    -d libyaml-dev \
    -d zlib1g-dev \
    -C /tmp/fpm \
    -p /{{.FileName}} \
    usr
