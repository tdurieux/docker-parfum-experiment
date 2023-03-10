FROM ubuntu

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV TZ 'Europe/Berlin'
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    make \
    ssh \
    sudo \
    curl \
    inetutils-ping \
	vim build-essential \
	clang llvm libblocksruntime-dev libpthread-workqueue-dev libxml2-dev cmake \
	libffi-dev \
	libreadline6-dev \
	libedit-dev \
	gnutls-dev && rm -rf /var/lib/apt/lists/*;



CMD ["bash"]

