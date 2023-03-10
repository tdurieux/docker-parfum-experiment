FROM node:8-stretch-slim

WORKDIR /app/

COPY package*.json ./

RUN npm install --production && npm cache clean --force;

COPY app.js runWithDapr.sh ./
COPY components ./components/

RUN chmod +x runWithDapr.sh

RUN wget https://github.com/dapr/dapr/releases/download/v0.3.0/daprd_linux_amd64.tar.gz
RUN tar -zxvf daprd_linux_amd64.tar.gz && rm daprd_linux_amd64.tar.gz

ENV PATH /app:$PATH

CMD ["/bin/bash", "runWithDapr.sh", "isbreaderapp", "3000"]
