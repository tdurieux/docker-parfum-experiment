FROM node:7.4
WORKDIR /devtools-backend

# install container dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
      curl \
      wget \
      vim \
      iptables \
      dpkg-dev \
      ssl-cert \
      openssh-client \
      libxml2 \
      git \
      python2.7 \
      python2.7-dev \
      python-pip \
      build-essential \
      libssl-dev \
      patch && rm -rf /var/lib/apt/lists/*;

# install project dependencies and build
ADD . /devtools-backend
RUN npm install && npm cache clean --force;
RUN npm run build

# expose standard debugger port
EXPOSE 9222

CMD ["npm", "run", "start"]
