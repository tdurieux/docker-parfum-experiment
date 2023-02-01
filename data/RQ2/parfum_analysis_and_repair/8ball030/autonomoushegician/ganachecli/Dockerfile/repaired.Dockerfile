# base image
FROM ubuntu:18.04
RUN apt-get update -y
RUN apt-get upgrade -y
RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install tzdata && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash
RUN apt-get install --no-install-recommends nodejs -y && rm -rf /var/lib/apt/lists/*;
RUN node -v
RUN npm -v

WORKDIR /app

ENV PATH /app/node_modules/.bin:$PATH

COPY package.json .
RUN npm install react-scripts@3.0.1 -g --silent && npm cache clean --force;
RUN npm install --silent && npm cache clean --force;
RUN npm install -g ganache-cli && npm cache clean --force;
COPY . /app
ENV PATH /app/node_modules/.bin:$PATH
# start app
CMD ["ganache-cli", "--host" , "0.0.0.0", "-p", "7545",  "-s", "1"]
