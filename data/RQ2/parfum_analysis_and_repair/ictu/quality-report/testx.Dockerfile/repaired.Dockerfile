FROM ictu/docker-protractor-headless

RUN npm install --loglevel=error -g coffee-script && npm cache clean --force;
ADD ./testx/ /root/quality-report/testx/
WORKDIR /root/quality-report/testx/
RUN npm install --loglevel=error && npm cache clean --force;
