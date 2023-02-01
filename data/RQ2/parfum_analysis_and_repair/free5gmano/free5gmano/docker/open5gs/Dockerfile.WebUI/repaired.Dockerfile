FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends curl wget -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -

RUN apt install --no-install-recommends nodejs -y && rm -rf /var/lib/apt/lists/*;

RUN wget https://github.com/open5gs/open5gs/archive/v2.1.7.tar.gz
RUN tar -zxvf v2.1.7.tar.gz && rm v2.1.7.tar.gz
RUN mv open5gs-2.1.7 open5gs

WORKDIR /open5gs/webui
RUN npm install && npm run build && npm cache clean --force;

CMD npm run start

EXPOSE 3000
