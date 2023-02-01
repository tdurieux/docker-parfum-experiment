FROM node:12.16.3-slim
RUN npm install -g sparrow-code && npm cache clean --force;
RUN sparrow start --init=true

# ENTRYPOINT [ "sparrow" ]
