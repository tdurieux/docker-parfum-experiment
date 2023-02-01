FROM docker

RUN apk add --no-cache python3 curl
RUN curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python3 get-pip.py
RUN pip install --no-cache-dir runlike

ENTRYPOINT ["runlike"]
