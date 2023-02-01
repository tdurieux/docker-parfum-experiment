FROM cooptilleuls/varnish:6.0-stretch

# install varnish-modules
RUN apt-get update -y && \
					apt-get install --no-install-recommends -y build-essential automake libtool curl git python-docutils && \
					curl -f -s https://packagecloud.io/install/repositories/varnishcache/varnish60/script.deb.sh | bash; rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y pkg-config libvarnishapi1 libvarnishapi-dev autotools-dev; rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/varnish/varnish-modules.git /tmp/vm;
RUN cd /tmp/vm; \
			git checkout 6.0; \
					./bootstrap && \
					./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)";

RUN cd /tmp/vm && \
			make && \
	    make check && \
	    make install;