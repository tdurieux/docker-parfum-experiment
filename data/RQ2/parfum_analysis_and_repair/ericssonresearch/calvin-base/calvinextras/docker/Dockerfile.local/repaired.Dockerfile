FROM erctcalvin/calvin:develop
MAINTAINER ola.angelsmark@ericsson.com
RUN apk --update --no-cache add curl
ADD calvin-base-head.tgz /
WORKDIR /calvin-base
EXPOSE 5000 5001
