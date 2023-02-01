FROM jfloff/alpine-python:latest

RUN apk add --no-cache --update jpeg-dev zlib-dev

# for a flask server
EXPOSE 5000

COPY requirements.txt /root/requirements.txt
RUN pip install --no-cache-dir -r /root/requirements.txt
RUN pip install --no-cache-dir gunicorn
CMD gunicorn -b 0.0.0.0:5000 mattermostgithub:app
