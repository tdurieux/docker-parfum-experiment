FROM ubi8/nodejs-12

USER 0
RUN mkdir -p /home/node/app
COPY base/packages/shopping /home/node/app
RUN chown -R 1001:0 /home/node/app

USER 1001
WORKDIR /home/node/app
ENV HOST=0.0.0.0 PORT=3000
EXPOSE ${PORT}
CMD [ "node", "." ]