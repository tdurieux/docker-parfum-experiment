FROM alpine:latest
WORKDIR /etc/
RUN mkdir -p /etc/Sphinx/build

RUN apk add --no-cache python3 py3-pip make git

RUN pip3 install --no-cache-dir git+https://github.com/sphinx-doc/sphinx
RUN pip3 install --no-cache-dir sphinx-autobuild
RUN pip3 install --no-cache-dir sphinx-rtd-theme

CMD sphinx-autobuild -b html --host 0.0.0.0 --port 80 /etc/Sphinx/source /etc/Sphinx/build
