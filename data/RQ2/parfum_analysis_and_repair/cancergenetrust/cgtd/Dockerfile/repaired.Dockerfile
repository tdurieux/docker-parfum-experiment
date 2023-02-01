FROM alpine:3.4

RUN apk add --no-cache --update python py-pip uwsgi uwsgi-python
RUN pip install --no-cache-dir --upgrade pip

# so we can curl from within the running container
RUN apk add --no-cache curl

# so we can install ipfsapi from git
RUN apk add --no-cache git

WORKDIR /app
ADD ./requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

ADD . /app

EXPOSE 5000

ENTRYPOINT ["uwsgi", "--ini", "uwsgi.ini"]
