FROM python:2.7

# needed for `column` command
RUN apt-get update && apt-get install --no-install-recommends -y bsdmainutils && rm -rf /var/lib/apt/lists/*;

ADD . /workspace
WORKDIR /workspace

EXPOSE 8080

CMD ["monitor/start.sh"]
