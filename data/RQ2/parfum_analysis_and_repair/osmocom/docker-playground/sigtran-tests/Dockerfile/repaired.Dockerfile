ARG	USER
FROM	$USER/debian-buster-build


RUN apt-get update && apt-get -y --no-install-recommends install \
		guile-2.0 guile-2.0-dev gnulib tcsh \
		python3 python3-pip && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir junit-xml

RUN cd /tmp && git clone https://github.com/nplab/guile-sctp && \
	cd guile-sctp && \
	./bootstrap && \
	./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
	make && \
	make install
