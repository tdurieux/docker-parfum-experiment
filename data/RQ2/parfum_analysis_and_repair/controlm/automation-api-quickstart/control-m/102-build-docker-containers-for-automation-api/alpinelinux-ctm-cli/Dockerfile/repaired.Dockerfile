#-------------------------------------------
# Container for Control-M Automation API cli
#-------------------------------------------

FROM mhart/alpine-node:latest
MAINTAINER Gad Ron <gad_ron@bmc.com>

ARG CTMHOST
ARG USER
ARG PASSWORD

# install nodejs
RUN apk add --no-cache --update nodejs \
  && npm -g install npm@latest \
	&& node -v \
	&& npm -v && npm cache clean --force;

# install ctm-automation-api kit
WORKDIR /root
RUN mkdir ctm-automation-api \
	&& cd ctm-automation-api \
	&& wget --no-check-certificate https://$CTMHOST:8443/automation-api/ctm-cli.tgz \
	&& npm install -g ctm-cli.tgz \
	&& ctm -v && npm cache clean --force;


# add controlm endpoint
RUN ctm env add endpoint https://$CTMHOST:8443/automation-api $USER $PASSWORD \
	&& ctm env set endpoint
