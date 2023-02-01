FROM node:14
MAINTAINER Ripple Operations <ops@ripple.com>

RUN mkdir /explorer
ADD . / explorer/
RUN npm --prefix explorer install && npm cache clean --force;
RUN chmod +x /explorer/entrypoint.sh
WORKDIR /explorer

CMD /explorer/entrypoint.sh
