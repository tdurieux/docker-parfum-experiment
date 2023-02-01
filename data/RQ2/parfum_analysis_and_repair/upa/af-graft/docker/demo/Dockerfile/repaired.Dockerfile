From ubuntu:latest


# install useful packages
RUN apt-get update && apt-get install --no-install-recommends -y \
	vim \
	iputils-ping \
	net-tools \
	iperf3 \
	netcat \
	nginx && rm -rf /var/lib/apt/lists/*;

# setup AF_GRAFT
COPY ./libgraft-convert.so /usr/local/lib/
COPY ./graft /usr/local/bin/

ENTRYPOINT [ "/usr/local/bin/graft", 		\
		"-i", "0.0.0.0:0-65535=ep-in4",	\
		"-i", ":::0-65535=ep-in6",	\
		"-e", "0.0.0.0/0=ep-out4",	\
		"-e", "::/0=ep-out6"	\
	]
