FROM python:3

RUN pip3 install --no-cache-dir --user websockets

WORKDIR /opt/
COPY . /opt/

CMD python -u ./simple_server.py --disable-ssl
