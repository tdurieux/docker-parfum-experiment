FROM golang:1.16.7

RUN apt-get update && apt-get install --no-install-recommends -y supervisor netcat && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /var/log/supervisor
RUN mkdir -p /home/app

WORKDIR /home/app
ADD . /home/app

ADD supervisor.conf /etc/supervisor.conf

# Running the entry point.
RUN chmod +x /home/app/entrypoint.sh
CMD [ "bash", "/home/app/entrypoint.sh" ]
