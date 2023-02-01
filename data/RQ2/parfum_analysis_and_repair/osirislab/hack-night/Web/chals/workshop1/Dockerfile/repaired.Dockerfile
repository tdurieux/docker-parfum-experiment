FROM ubuntu:18.04

MAINTAINER Kent Ma

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y python-pip python-dev libgmp3-dev libmpfr-dev libmpc-dev && rm -rf /var/lib/apt/lists/*;

# We copy just the requirements.txt first to leverage Docker cache
COPY ./requirements.txt /app/requirements.txt
COPY flag.txt /flag.txt

WORKDIR /app

RUN pip install --no-cache-dir -r requirements.txt

COPY /site /app
EXPOSE 5000

ENTRYPOINT [ "python" ]

CMD [ "app.py" ]
