FROM google/nodejs
MAINTAINER Hugues MALPHETTES <hmalphettes@gmail.com>

WORKDIR /app
ADD . /app
RUN npm install --unsafe-perm && npm cache clean --force;

EXPOSE 3003

CMD ["/nodejs/bin/npm", "start"]
