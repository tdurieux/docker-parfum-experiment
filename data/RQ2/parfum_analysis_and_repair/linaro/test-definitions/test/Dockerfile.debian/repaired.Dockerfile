FROM python:2.7

RUN apt-get update && apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;

COPY . /work
WORKDIR /work
RUN pip install --no-cache-dir -r automated/utils/requirements.txt

CMD . ./automated/bin/setenv.sh && test-runner -p plans/linux-example.yaml && bash

