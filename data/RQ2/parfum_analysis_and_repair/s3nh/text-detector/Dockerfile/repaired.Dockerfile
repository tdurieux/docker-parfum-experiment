FROM ubuntu:16.04
MAINTAINER S3nh "steam.panek@gmail.com"
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y python-pip python-dev && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /app/requirements.txt
WORKDIR /app
COPY . /app
ENTRYPOINT ["python"]
CMD [ "app.py" ]





