FROM python:3

WORKDIR /usr/src/nano-dlna/
COPY . /usr/src/nano-dlna/

RUN pip install --no-cache-dir --no-cache .

ENTRYPOINT [ "nanodlna" ]
CMD [ "--help" ]
