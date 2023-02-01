FROM node:6.5.0

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
RUN mkdir /usr/src/app/output && rm -rf /usr/src/app/output
WORKDIR /usr/src/app

COPY package.json /usr/src/app/
COPY . /usr/src/app

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y \
    build-essential \
    gcc \
    libpq-dev \
    make \
    python-pip \
    python2.7 \
    python2.7-dev \
    ssh \
    && apt-get autoremove \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -U "pip==9.0.1"
RUN pip install --no-cache-dir -U "virtualenv==12.0.7"
RUN pip install --no-cache-dir -r "requirements.txt"

RUN npm config set python python2.7

RUN npm install && npm cache clean --force;

CMD node start.js
