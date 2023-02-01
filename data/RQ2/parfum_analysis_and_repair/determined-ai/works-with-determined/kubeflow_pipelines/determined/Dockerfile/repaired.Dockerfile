FROM python:3.7-slim

RUN apt-get update && apt-get install --no-install-recommends -y gcc python3-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir determined-cli==0.13.0 determined==0.13.0

RUN mkdir /cmd/
WORKDIR /cmd/

COPY . /cmd/

ENTRYPOINT ["/bin/sh"]
