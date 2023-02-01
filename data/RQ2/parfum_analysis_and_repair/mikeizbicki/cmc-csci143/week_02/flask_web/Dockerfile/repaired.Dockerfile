FROM ubuntu:16.04

MAINTAINER Mike Izbicki "mike@izbicki.me"

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y python-pip python-dev && rm -rf /var/lib/apt/lists/*;

# We copy just the requirements.txt first to leverage Docker cache
COPY ./requirements.txt /app/requirements.txt

WORKDIR /app

RUN pip install --no-cache-dir -r requirements.txt

COPY . /app

ENTRYPOINT [ "python" ]

CMD [ "app.py" ]
