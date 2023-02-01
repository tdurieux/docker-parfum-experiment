FROM centos:7

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
	    python3 \
	    python-sphinx
