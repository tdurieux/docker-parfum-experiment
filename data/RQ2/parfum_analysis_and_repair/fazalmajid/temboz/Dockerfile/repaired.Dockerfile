FROM alpine
RUN apk add --no-cache --update python3-dev py3-cffi gcc linux-headers musl-dev sqlite
RUN python3 -m ensurepip
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir flask
RUN pip3 install --no-cache-dir requests
RUN pip3 install --no-cache-dir html5lib
RUN pip3 install --no-cache-dir passlib
RUN pip3 install --no-cache-dir argon2_cffi
RUN pip3 install --no-cache-dir translitcodec
RUN pip3 install --no-cache-dir waitress
RUN pip3 install --no-cache-dir feedparser
#RUN pip3 install yappi
COPY . /temboz
RUN rm -f /temboz/tembozapp/feedparser.py
VOLUME ["/temboz/data"]
WORKDIR /temboz/data
ENV DOCKER=true
EXPOSE 9999/tcp
ENTRYPOINT ["python3", "-v", "/temboz/temboz", "--server"]
