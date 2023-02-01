FROM ubuntu:16.04

ARG uid=1000
ARG indy_stream=stable

ENV LC_ALL="C.UTF-8"
ENV LANG="C.UTF-8"
ENV SHELL="/bin/bash"

# Python 3.6
RUN apt-get update
RUN apt-get install --no-install-recommends -y software-properties-common vim && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:jonathonf/python-3.6
RUN apt-get update

RUN apt-get install --no-install-recommends -y build-essential python3.6 python3.6-dev python3-pip python3.6-venv && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# update pip
RUN python3.6 -m pip install pip --upgrade
RUN python3.6 -m pip install wheel

# Install environment
RUN apt-get update -y && apt-get install --no-install-recommends -y \
    wget \
    python-setuptools \
    python3-nacl \
    apt-transport-https \
    ca-certificates \
    build-essential \
    pkg-config \
    cmake \
    libssl-dev \
    libsqlite3-dev \
    libsodium-dev \
    curl && rm -rf /var/lib/apt/lists/*;

# Add indy user
RUN useradd -ms /bin/bash -u $uid indy

# Install LibIndy
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 68DB5E88
RUN echo "deb https://repo.sovrin.org/sdk/deb xenial $indy_stream" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install --no-install-recommends -y libindy && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

COPY . /app

RUN pip install --no-cache-dir --trusted-host pypi.python.org -r requirements.txt

ARG PORT

ENV PORT=${PORT}

EXPOSE $PORT

CMD python3.6 indy-agent.py $PORT