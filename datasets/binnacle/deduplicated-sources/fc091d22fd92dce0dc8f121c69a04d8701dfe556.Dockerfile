FROM wikimedia/nodejs
RUN apt-get update && apt-get install -y librsvg2-dev && rm -rf /var/lib/apt/lists/*
RUN mkdir /opt/service
ADD . /opt/service
WORKDIR /opt/service
ENV HOME=/root LINK=g++
RUN npm install && npm dedupe
ENV IN_DOCKER=1
CMD npm start
