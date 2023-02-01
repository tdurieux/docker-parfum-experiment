FROM python:alpine
MAINTAINER Sysdig <support@sysdig.com>

WORKDIR /app
ADD requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

ADD bot.py /app
ENTRYPOINT [ "python", "bot.py" ]
