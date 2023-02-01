FROM node:alpine
RUN npm install -g corona-cli && npm cache clean --force;
ENTRYPOINT [ "/usr/local/bin/corona" ]
CMD [ "--help" ]
