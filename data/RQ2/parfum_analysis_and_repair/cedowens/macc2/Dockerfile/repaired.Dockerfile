FROM python:3

RUN mkdir -p /macc2

ADD * /macc2/

WORKDIR /macc2

RUN pip3 install --no-cache-dir aiohttp

CMD ["python3", "MacC2_server.py"]
