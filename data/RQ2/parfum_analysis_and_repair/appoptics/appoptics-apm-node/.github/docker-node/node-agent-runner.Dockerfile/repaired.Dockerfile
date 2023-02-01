FROM ubuntu:20.04
SHELL ["/bin/bash", "-c"]

# general tools
RUN apt update \
    && apt -y --no-install-recommends install \
                curl \
                git \
                g++ \
                python \
                make && rm -rf /var/lib/apt/lists/*;

# set time zone (for github cli)
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# for github cli
RUN apt -y --no-install-recommends install \
            gnupg \
            software-properties-common \
            tzdata && rm -rf /var/lib/apt/lists/*;

# get and install github cli
# see: https://github.com/cli/cli/issues/1797#issuecomment-696469523
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0 \
    && apt-add-repository https://cli.github.com/packages \
    && apt -y --no-install-recommends install gh && rm -rf /var/lib/apt/lists/*;

# Install tools needed for specific service tests (pg, oracle)
RUN apt -y --no-install-recommends install \
            libaio1 \
            postgresql-server-dev-12 \
            zip \
            unzip && rm -rf /var/lib/apt/lists/*;

# get and install oracle library
RUN curl -f -LO https://download.oracle.com/otn_software/linux/instantclient/195000/instantclient-basic-linux.x64-19.5.0.0.0dbru.zip \
    && mkdir /opt/oracle \
    && unzip instantclient-basic-linux.x64-19.5.0.0.0dbru.zip -d /opt/oracle/ \
    && rm instantclient-basic-linux.x64-19.5.0.0.0dbru.zip

# set for usage
ENV LD_LIBRARY_PATH /opt/oracle/instantclient_19_5:$LD_LIBRARY_PATH
