FROM python:3-alpine3.10

WORKDIR /opt

RUN apk update && apk add --no-cache git
RUN git clone https://github.com/swisskyrepo/SSRFmap.git
RUN cd /opt/SSRFmap && pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python3","/opt/SSRFmap/ssrfmap.py"]
