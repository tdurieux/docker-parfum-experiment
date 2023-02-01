FROM debian:10
ARG INSTALL_ZKAY=0
ARG PYTHON_VERSION=3.8.12

#############
# LIBSNARK #
#############
# the relevant dependencies to obtain and compile libsnarks
RUN apt-get update && apt-get install --no-install-recommends -y \
		git \
		build-essential \
		cmake \
		libgmp-dev \
		pkg-config \
		libssl-dev \
		libboost-dev \
		libboost-program-options-dev \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

########
# JAVA #
########
# required to install default-jdk-headless
RUN mkdir -p /usr/share/man/man1
RUN apt-get update && apt-get install --no-install-recommends -y \
		default-jdk-headless \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

##########
# PYTHON #
##########
# recent python versions need to be built from source
RUN apt-get update && apt-get install --no-install-recommends -y \
		wget \
        zlib1g-dev \
		libffi-dev \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*
RUN wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz \
    && tar xzf Python-$PYTHON_VERSION.tgz \
    && cd Python-$PYTHON_VERSION \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-optimizations \
    && make install && rm Python-$PYTHON_VERSION.tgz
RUN ln -s /usr/local/bin/pip3 /usr/local/bin/pip && \
	ln -s /usr/local/bin/python3 /usr/local/bin/python

###################
# ZKAY (OPTIONAL) #
###################
RUN if [ "$INSTALL_ZKAY" = "1" ]; then \
		git clone https://github.com/eth-sri/zkay.git && \
			cd zkay/babygiant-lib && \
		    sh ./install.sh && \
			cd .. && \
			pip install --no-cache-dir -e .; \
	fi
