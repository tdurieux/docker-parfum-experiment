FROM python:3-alpine

RUN apk add --no-cache zip unzip
RUN addgroup --system scar && adduser -S -G scar scar
USER scar

WORKDIR /home/scar/
RUN mkdir /home/scar/.scar && \ 
  mkdir /home/scar/.aws && \
  echo '[default]' > /home/scar/.aws/config && \
  echo 'region=us-east-1' >> /home/scar/.aws/config && \
  echo '[default]' > /home/scar/.aws/credentials && \
  echo 'aws_access_key_id=' >> /home/scar/.aws/credentials && \
  echo 'aws_secret_access_key=' >> /home/scar/.aws/credentials

ENV PATH=/home/scar/.local/bin:$PATH
ENV SCAR_LOG_PATH=/home/scar/.scar/

RUN pip3 install --no-cache-dir scar --user

ENTRYPOINT /bin/sh