FROM ubuntu:bionic

RUN apt-get update --fix-missing && apt-get -y install curl

# Set the timezone
RUN ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

# install node
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

ENV DEBIAN_FRONTEND noninteractive
# Default Python file.open file encoding to UTF-8 instead of ASCII, workaround for le-utils setup.py issue
ENV LANG C.UTF-8
RUN apt-get update && apt-get -y install nodejs python-minimal python3.6 python3-pip python3-dev gcc libpq-dev make git curl libjpeg-dev

# Ensure that python is using python3
# copying approach from official python images
ENV PATH /usr/local/bin:$PATH
RUN cd /usr/local/bin && \
  ln -s $(which python3) python && \
  ln -s $(which pip3) pip

RUN npm install -g yarn

COPY ./package.json .
COPY ./yarn.lock .
RUN yarn install

COPY requirements.txt .

RUN pip install --upgrade pip
RUN pip install --ignore-installed -r requirements.txt

COPY  . /contentcuration/
WORKDIR /contentcuration

# generate the node bundles
RUN mkdir -p contentcuration/static/js/bundles
RUN ln -s /node_modules /contentcuration/node_modules
RUN yarn run build -p

EXPOSE 8000

ENTRYPOINT ["make", "altprodserver"]
