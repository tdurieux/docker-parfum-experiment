FROM python:3.6.4
MAINTAINER furion <_@furion.me>

COPY . /app
WORKDIR /app

ENV UNLOCK foo

RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir git+git://github.com/Netherdrake/steem-python@master
RUN pip install --no-cache-dir git+git://github.com/SteemData/steemdata@master

WORKDIR /app/src
CMD ["python", "__main__.py"]
