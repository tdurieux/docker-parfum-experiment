FROM alpine:3.10.3

RUN apk update && apk add --no-cache py3-jinja2 bash make ncurses
RUN pip3 install --no-cache-dir --upgrade pip setuptools
RUN pip3 install --no-cache-dir 'jinja2-cli[yaml]'

ENTRYPOINT [ "jinja2" ]