#To build docker image from this file run
#docker build .
#on terminal

FROM python:3.6-alpine
#LABEL MAINTAINER

# Copying files
COPY wplay/ /whatsapp-play/wplay
COPY setup.py /whatsapp-play/setup.py
COPY README.md /whatsapp-play/README.md
COPY requirements.txt /whatsapp-play/requirements.txt

# Dependencies
WORKDIR /whatsapp-play
RUN apk add --no-cache build-base
RUN apk add --no-cache make
RUN apk add --no-cache gcc musl-dev libffi-dev openssl-dev
RUN pip install --no-cache-dir cryptography==2.9.0
RUN apk add --no-cache libffi-dev
RUN apk add --no-cache build-base
RUN apk add --no-cache py3-pip
RUN apk add --no-cache python3-dev
RUN pip install --no-cache-dir cffi==1.14.0
RUN pip install --no-cache-dir -r requirements.txt

#ENTRYPOINT echo "Hello, welcome to whatsapp-play"
ENTRYPOINT ["python3 -m wplay -h"]

CMD [ "python"]