FROM node:6.2
MAINTAINER Ivan Drondov

# Dependencies for canvas library
RUN apt-get install -y --no-install-recommends libcairo2-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /home/src
# For caching firstly copy only package.json
COPY ./package.json /home/src
RUN npm install && npm cache clean --force;

# Copy remaining code
COPY . /home/src
