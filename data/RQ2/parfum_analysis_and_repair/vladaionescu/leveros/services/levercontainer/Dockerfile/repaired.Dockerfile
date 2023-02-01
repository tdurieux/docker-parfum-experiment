FROM ubuntu:latest

LABEL com.leveros.isleveros="true"
LABEL com.leveros.islevercontainer="true"

RUN apt-get update
RUN apt-get dist-upgrade -y

RUN apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    dialog \
    git \
    libevent-dev \
    nano \
    net-tools \
    python \
    python-dev \
    python-distribute \
    python-pip \
    python-software-properties \
    software-properties-common \
    tar \
    unzip \
    wget && rm -rf /var/lib/apt/lists/*;

# Install NodeJS.
RUN curl -f -sL https://deb.nodesource.com/setup_5.x | bash -
RUN apt-get update
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# JS server.
RUN npm install -g grunt-cli && npm cache clean --force;
COPY js/leveros-common/package.json /leveros/js/leveros-common/
RUN cd /leveros/js/leveros-common && npm install && npm cache clean --force;
COPY js/leveros-server/package.json /leveros/js/leveros-server/
RUN cd /leveros/js/leveros-server && npm link ../leveros-common
RUN cd /leveros/js/leveros-server && npm install && npm cache clean --force;
COPY js/leveros-common /leveros/js/leveros-common
RUN cd /leveros/js/leveros-common && grunt compile
COPY js/leveros-server /leveros/js/leveros-server
RUN cd /leveros/js/leveros-server && grunt compile

# This is really important to avoid Lever customers from running as root.
# Without ns remap it would mean that in case of a breakout they would have
# root access to the host.
RUN groupadd -r lever
RUN useradd -g lever -s /sbin/nologin lever
USER lever

# Port listening on for Lever RPCs.
EXPOSE 3837

# The customer code that will handle Lever RPCs.
VOLUME /leveros/custcode

WORKDIR /leveros/custcode
