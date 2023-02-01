FROM ubuntu:trusty

RUN apt-get update && apt-get install --no-install-recommends -yq curl && apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

ADD tests.sh /app/tests.sh

CMD ["bash", "tests.sh"]
