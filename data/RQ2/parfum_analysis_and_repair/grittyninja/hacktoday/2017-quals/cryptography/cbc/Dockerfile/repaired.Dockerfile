FROM python:2

WORKDIR /usr/src/app

RUN pip install --no-cache-dir pycrypto

COPY cbc_server.py .
COPY rahasia.py .

CMD [ "python", "./cbc_server.py" ]

