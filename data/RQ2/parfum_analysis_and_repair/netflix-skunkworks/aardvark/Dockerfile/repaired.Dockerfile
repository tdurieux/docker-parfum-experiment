FROM python:3.7

RUN apt-get update -y \
    && apt-get upgrade -y \
    && mkdir -p /usr/src/aardvark \
    && pip install --no-cache-dir --upgrade wheel setuptools pip && rm -rf /usr/src/aardvark

WORKDIR /usr/src/aardvark

COPY . /usr/src/aardvark
RUN pip install --no-cache-dir .

WORKDIR /etc/aardvark

ENV AARDVARK_DATA_DIR=/data \
    AARDVARK_ROLE=Aardvark \
    ARN_PARTITION=aws \
    AWS_DEFAULT_REGION=us-east-1

EXPOSE 5000

COPY ./entrypoint.sh /etc/aardvark/entrypoint.sh

ENTRYPOINT [ "/etc/aardvark/entrypoint.sh" ]

CMD [ "aardvark" ]
