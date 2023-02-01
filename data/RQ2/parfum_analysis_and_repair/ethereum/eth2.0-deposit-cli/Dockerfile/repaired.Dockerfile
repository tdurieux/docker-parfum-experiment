FROM python:alpine3.14

WORKDIR /app

COPY requirements.txt setup.py ./

COPY staking_deposit ./staking_deposit

RUN apk add --no-cache --update gcc libc-dev linux-headers

RUN pip3 install --no-cache-dir -r requirements.txt

RUN python3 setup.py install

ARG cli_command

ENTRYPOINT [ "python3", "./staking_deposit/deposit.py" ]

CMD [ $cli_command ]
