FROM python:2.7

WORKDIR /aws-amicleaner

ADD . .

RUN pip install --no-cache-dir -r requirements.txt

CMD amicleaner/cli.py -h
