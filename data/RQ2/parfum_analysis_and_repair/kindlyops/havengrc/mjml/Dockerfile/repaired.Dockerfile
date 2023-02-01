FROM node:alpine

RUN apk --update --no-cache add bash wget dpkg-dev \
	&& mkdir -p /home/mjml/ \
	&& mkdir -p /home/mjml/templates \
	&& mkdir -p /home/mjml/dist \
	&& npm init -y \
	&& npm install -g mjml && npm cache clean --force;

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /home/mjml

ENTRYPOINT ["/entrypoint.sh"]

