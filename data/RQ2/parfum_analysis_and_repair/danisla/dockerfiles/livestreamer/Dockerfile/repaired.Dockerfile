FROM python:3-slim
MAINTAINER "Dan Isla <dan.isla@gmail.com>"

RUN apt-get update && apt-get install -y --no-install-recommends \
    rtmpdump \
  && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir livestreamer

ENTRYPOINT ["livestreamer", "--player-external-http", "--player-external-http-port=8000", "--yes-run-as-root", "--default-stream=best"]
