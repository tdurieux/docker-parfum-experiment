FROM node:8.14.0-stretch AS com.yakindu.solidity.web.login
LABEL maintainer="itemis AG"

# Install SW as root
RUN addgroup docker --gid=994
RUN usermod -aG docker node

#Switch to User node
USER node
WORKDIR /home/node

# Get sourcen an remove unneeded ones
RUN git clone https://github.com/Yakindu/solidity-ide.git \
    && cp -r solidity-ide/extensions/theia/login ./login \
    && rm -rf solidity-ide/

#compile sources
WORKDIR /home/node/login
RUN mkdir files && echo "{}" > ./files/ides.json
RUN npm i
RUN npm run build

# Startup
EXPOSE 4242
CMD npm run parallel