FROM dckreg:5000/openjdk:8-jdk

ENV PATH $PATH:/opt/node/bin
RUN wget https://nodejs.org/dist/v6.9.0/node-v6.9.0-linux-x64.tar.gz
RUN tar xvf node-v6.9.0-linux-x64.tar.gz && rm node-v6.9.0-linux-x64.tar.gz
RUN rm node-v6.9.0-linux-x64.tar.gz
RUN mv  node-v6.9.0-linux-x64 /opt/node
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libsasl2-dev && rm -rf /var/lib/apt/lists/*;
COPY app /app
WORKDIR /app
RUN npm install node-rdkafka && npm cache clean --force;
RUN npm install && npm cache clean --force;
