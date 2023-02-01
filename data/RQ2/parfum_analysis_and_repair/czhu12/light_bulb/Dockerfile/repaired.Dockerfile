FROM ubuntu:16.04
RUN apt-get update && apt-get install --no-install-recommends -y curl software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:jonathonf/python-3.6

RUN apt-get install -y --no-install-recommends apt-transport-https && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN curl -f -sL https://deb.nodesource.com/setup_9.x | bash

RUN apt-get update && apt-get install --no-install-recommends -y python3 python3-dev python3-pip python3-venv && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl software-properties-common yarn nodejs unzip && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /app/light_bulb/ui/build
RUN mkdir -p /app/light_bulb/ui/public
WORKDIR /app

ADD Makefile /app/Makefile

# Install vendor dependencies
#RUN make vendor vendor/glove.6B

# Install python dependencies
ADD requirements.txt /app/requirements.txt

RUN pip3 install --no-cache-dir virtualenv
RUN make .virt

# Add code
ADD . /app

WORKDIR /app
RUN make light_bulb/ui/build/index.html
