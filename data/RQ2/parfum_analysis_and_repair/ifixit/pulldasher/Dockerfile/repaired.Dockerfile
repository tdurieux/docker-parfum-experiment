FROM node:16-alpine

RUN mkdir -p /opt/pulldasher
WORKDIR /opt/pulldasher

# Install dependencies
COPY . /opt/pulldasher
RUN npm install --unsafe-perm && npm cache clean --force;
ENV DEBUG=pulldasher:*

EXPOSE 8080
CMD ["bin/pulldasher"]
