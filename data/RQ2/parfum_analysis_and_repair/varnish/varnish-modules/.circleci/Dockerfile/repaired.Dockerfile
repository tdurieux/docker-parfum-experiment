FROM centos:7

# on master, install varnish from source to avaoid any lag
RUN set -e; \
	yum install -y epel-release; rm -rf /var/cache/yum \
	yum install -y \
	    automake \
	    git \
	    jemalloc-devel \
	    libedit-devel \
	    libtool \
	    libunwind-devel \
	    make \
	    pcre2-devel \
	    python-sphinx \
	    python3; \
	git clone https://github.com/varnishcache/varnish-cache.git /tmp/varnish-cache; \
	cd /tmp/varnish-cache; \
	./autogen.des; \
	./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --libdir=/usr/lib64; \
	make -j 8; \
	make install
