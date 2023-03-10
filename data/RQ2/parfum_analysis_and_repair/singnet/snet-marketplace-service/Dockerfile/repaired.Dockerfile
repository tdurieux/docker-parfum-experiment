ARG BASE_IMAGE=ubuntu:18.04
FROM $BASE_IMAGE

WORKDIR /opt/app/
COPY wallets/requirements.txt ./
RUN pip3 install --no-cache-dir --upgrade awscli
RUN pip3 install --no-cache-dir -r requirements.txt
COPY wallets/package.json package.json
RUN npm install && npm cache clean --force;
COPY wallets/ wallets/
COPY common/ common/

ENTRYPOINT bash wallets/bootstrap.sh