FROM ubuntu:trusty

RUN apt-get update && apt-get install --no-install-recommends -yq curl && apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

ADD wait-for-it/wait-for-it.sh /app/
ADD appsettings.json /app/
ADD set-config.sh /app/
ADD test.sh /app/
ADD tests /app/tests
