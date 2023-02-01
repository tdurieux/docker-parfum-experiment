FROM ubuntu:latest
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y tzdata && dpkg-reconfigure --frontend noninteractive tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential cmake git libjson-c-dev uuid-dev git \
																python3-dev python3-wheel python3-pip doxygen libedit-dev \
									libcap-dev libudev-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /root
ENTRYPOINT [ "/bin/bash", "-c" ]


