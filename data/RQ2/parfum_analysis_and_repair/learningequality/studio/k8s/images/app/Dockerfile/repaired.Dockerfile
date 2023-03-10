FROM ubuntu:bionic

RUN apt-get update --fix-missing && apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;

# Set the timezone
RUN ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

# install node
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -

ENV DEBIAN_FRONTEND noninteractive
# Default Python file.open file encoding to UTF-8 instead of ASCII, workaround for le-utils setup.py issue
ENV LANG C.UTF-8
RUN apt-get update && apt-get -y --no-install-recommends install nodejs python-minimal python3.6 python3-pip python3-dev gcc libpq-dev make git curl libjpeg-dev && rm -rf /var/lib/apt/lists/*;

# Ensure that python is using python3
# copying approach from official python images
ENV PATH /usr/local/bin:$PATH
RUN cd /usr/local/bin && \
  ln -s $(which python3) python && \
  ln -s $(which pip3) pip

RUN npm install -g yarn && npm cache clean --force;

COPY ./package.json .
COPY ./yarn.lock .
RUN yarn install && yarn cache clean;

COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir --ignore-installed -r requirements.txt

COPY  . /contentcuration/
WORKDIR /contentcuration

# generate the node bundles
RUN mkdir -p contentcuration/static/js/bundles
RUN ln -s /node_modules /contentcuration/node_modules
RUN yarn run build -p && yarn cache clean;

EXPOSE 8000

ENTRYPOINT ["make", "altprodserver"]
