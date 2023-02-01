FROM node:latest

RUN apt-get update -qq
# RUN add-apt-repository -y ppa:kubuntu-ppa/backports
RUN apt-get update
RUN apt-get install --no-install-recommends --force-yes --yes libcv-dev libcvaux-dev libhighgui-dev libopencv-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir node_modules
RUN npm install mocha nierika rfb2 && npm cache clean --force;

CMD /node_modules/.bin/mocha /test
