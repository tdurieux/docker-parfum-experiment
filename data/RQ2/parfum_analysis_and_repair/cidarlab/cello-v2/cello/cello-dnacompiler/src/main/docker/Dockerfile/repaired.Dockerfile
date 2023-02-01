FROM adoptopenjdk/openjdk8:debian

VOLUME /tmp

ARG JAR_FILE

RUN echo "deb http://deb.debian.org/debian buster-backports main" >> /etc/apt/sources.list
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends curl python3 gcc-multilib && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends -t buster-backports yosys && rm -rf /var/lib/apt/lists/*;

RUN cd /root && \
	curl -f -s -L https://glaros.dtc.umn.edu/gkhome/fetch/sw/hmetis/hmetis-1.5-linux.tar.gz --output hmetis-1.5-linux.tar.gz && \
	tar xzf hmetis-1.5-linux.tar.gz && \
	cd hmetis-1.5-linux && \
	install hmetis /usr/bin && rm hmetis-1.5-linux.tar.gz

RUN	update-alternatives --install /usr/bin/python python /usr/bin/python3 1
RUN apt-get install -y --no-install-recommends python3-pip python3-setuptools git && \
	pip3 install --no-cache-dir wheel matplotlib numpy sympy && \
	pip3 install --no-cache-dir dnaplotlib && \
	pip3 install --no-cache-dir git+https://github.com/CIDARLAB/pycello-v2 && rm -rf /var/lib/apt/lists/*;

RUN apt-get autoremove -y

COPY target/${JAR_FILE} /root/app.jar
