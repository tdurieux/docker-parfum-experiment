FROM ubuntu:16.04

MAINTAINER Jeremy Magland

# Install utils
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    curl htop git && rm -rf /var/lib/apt/lists/*;

# Install nodejs
RUN curl -f -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh && \
	bash nodesource_setup.sh
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    nodejs && rm -rf /var/lib/apt/lists/*;

# Install mongodb
RUN mkdir -p /data/db
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    mongodb && rm -rf /var/lib/apt/lists/*;

# Install python and pip
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    python3 python3-pip && rm -rf /var/lib/apt/lists/*;

# Install mountainlab-js
WORKDIR /working
ADD https://api.github.com/repos/flatironinstitute/mountainlab-js/git/refs/heads/master version-mountainlab-js.json
RUN git clone https://github.com/flatironinstitute/mountainlab-js
WORKDIR /working/mountainlab-js
RUN npm install --unsafe-perm && npm cache clean --force; # unsafe-perm is required here because we are root
ENV PATH /working/mountainlab-js/bin:$PATH

# Install packages
RUN mkdir -p /working/.mountainlab/packages
WORKDIR /working/.mountainlab/packages
ENV ML_PACKAGE_SEARCH_DIRECTORY /working/.mountainlab/packages

ADD https://api.github.com/repos/magland/ml_ephys/git/refs/heads/master version-ml_ephys.json
RUN git clone https://github.com/magland/ml_ephys
RUN cd ml_ephys && pip3 install --no-cache-dir --upgrade -r requirements.txt

ADD https://api.github.com/repos/magland/ml_ms4alg/git/refs/heads/master version-ml_ms4alg.json
RUN git clone https://github.com/magland/ml_ms4alg
RUN cd ml_ms4alg && pip3 install --no-cache-dir --upgrade -r requirements.txt

WORKDIR /working
COPY test_in_container.sh /working/test_in_container.sh

CMD /bin/bash -c "mongod --fork --logpath /var/log/mongodb.log && sleep 1 && /working/test_in_container.sh"