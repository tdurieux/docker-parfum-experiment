# A dockerized version of the tool emailharvester by maldevel

FROM python:alpine

RUN apk -U upgrade && apk add --no-cache git
RUN git clone https://github.com/maldevel/EmailHarvester
WORKDIR /EmailHarvester
RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /EmailHarvester
ENTRYPOINT ["python", "EmailHarvester.py"]
