FROM ubi8/nodejs-12

USER 0
RUN mkdir -p /home/node/app
COPY . /home/node/app
RUN chown -R 1001:0 /home/node/app

USER 1001
WORKDIR /home/node/app
RUN HUSKY_SKIP_INSTALL=1 npm ci && npm run build