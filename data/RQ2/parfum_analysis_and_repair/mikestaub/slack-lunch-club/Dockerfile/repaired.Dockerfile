FROM mikestaub/serverless-node-puppeteer:8.10.0

RUN yarn global add npm-check-updates

# install arangodump and arangorestore binaries
RUN apt-get update
RUN curl -f -O https://download.arangodb.com/arangodb33/xUbuntu_16.04/Release.key
RUN apt-key add - < Release.key
RUN echo 'deb https://download.arangodb.com/arangodb33/xUbuntu_16.04/ /' | tee /etc/apt/sources.list.d/arangodb.list
RUN echo 'deb http://ftp.debian.org/debian jessie-backports main' >> /etc/apt/sources.list
RUN apt-get install --no-install-recommends -y apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN echo 'installing arangodb v3.3.8'
RUN apt-get update
RUN apt-get install --no-install-recommends -y libssl1.0.0=1.0.2l-1~bpo8+1 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y arangodb3-client=3.3.8 && rm -rf /var/lib/apt/lists/*;

# add env vars to bash session (requires ./secrets.js file exist)
RUN echo 'export $(npm run --silent print-env-vars)' >> ~/.bashrc

WORKDIR /opt/app