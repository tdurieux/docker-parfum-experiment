FROM ubuntu:16.04

# install utilities
RUN apt-get update -yqq \
 && apt-get install --no-install-recommends -yqq \
 unzip \
 curl \
 git \
 ssh \
 gcc \
 make \
 build-essential \
 libkrb5-dev \
 sudo \
 apt-utils && rm -rf /var/lib/apt/lists/*;

RUN sudo apt-get install --no-install-recommends -y python3 python3-pip && \
    pip3 install --no-cache-dir --upgrade pip && rm -rf /var/lib/apt/lists/*;

RUN sudo apt-get install --no-install-recommends -y libmysqlclient-dev sqlite3 && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN sudo apt-get install --no-install-recommends -yq nodejs \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD . /code
WORKDIR /code

RUN pip3 install --no-cache-dir -r lib/atm/requirements.txt

RUN pip3 install --no-cache-dir lib/atm/

RUN pip3 install --no-cache-dir -r server/requirements.txt

RUN pip3 uninstall -y scikit_learn
RUN pip3 install --no-cache-dir scikit_learn==0.19.2

RUN npm install --quiet && npm cache clean --force;

RUN npm run build

EXPOSE 5000

# ENTRYPOINT [ "python" ]
ENV PYTHONPATH "${PYTHONPATH}:/code/server"
