FROM ubuntu:14.04

ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb http://download.mono-project.com/repo/debian wheezy main" > /etc/apt/sources.list.d/mono-xamarin.list
RUN echo "deb http://download.mono-project.com/repo/debian wheezy-apache24-compat main" >> /etc/apt/sources.list.d/mono-xamarin.list
RUN apt-get update && apt-get install --no-install-recommends -y \
        git \
        build-essential \
        autoconf \
        libtool \
        automake \
        gettext \
        mono-xbuild \
        ccache \
        libmono-microsoft-build-tasks-v4.0-4.0-cil \
        mono-complete \
        nuget \
        python-dev \
        python-openssl \
        python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir buildbot==0.8.12

RUN pip install --no-cache-dir buildbot-slave==0.8.12

RUN cd /tmp && \
	curl -f -O http://valgrind.org/downloads/valgrind-3.11.0.tar.bz2 && \
	tar -jxf valgrind-3.11.0.tar.bz2 && \
	cd valgrind-3.11.0 && \
	./autogen.sh && \
	./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/opt/valgrind && \
	make -j4 && \
	make install && rm valgrind-3.11.0.tar.bz2
RUN rm -rf /tmp/valgrind*

ADD run_ec2slave.sh /usr/local/bin/run_ec2slave.sh
RUN chmod +x /usr/local/bin/run_ec2slave.sh
ENTRYPOINT ["/usr/local/bin/run_ec2slave.sh"]
