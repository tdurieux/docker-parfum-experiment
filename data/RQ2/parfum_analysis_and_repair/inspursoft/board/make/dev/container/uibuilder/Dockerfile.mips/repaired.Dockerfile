FROM inspursoft/node-mips:10.16.3

RUN mkdir -p /board_resource

COPY src/ui/package.json /board_resource
COPY make/dev/container/uibuilder/entrypoint.sh /

WORKDIR /board_resource

RUN mkdir -p /board_src \
	&& npm config set registry https://registry.npm.taobao.org \
    && npm install -g @angular/cli@latest \
    && npm install \
    && chmod u+x /entrypoint.sh && npm cache clean --force;
VOLUME ["/board_src"]
