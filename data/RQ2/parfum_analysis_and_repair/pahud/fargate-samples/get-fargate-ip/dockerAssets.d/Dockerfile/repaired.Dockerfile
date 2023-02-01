FROM node:alpine

RUN apk add --no-cache curl jq groff less python3 && \
 pip3 install --no-cache-dir awscli

RUN mkdir /app
ADD index.js /app
ADD run.sh /root
RUN chmod a+x /root/run.sh

CMD /root/run.sh
