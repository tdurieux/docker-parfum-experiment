FROM registry.opensource.zalan.do/library/python-3.8-slim:latest

RUN apt-get update && apt-get install --no-install-recommends -y python3-dev libffi-dev libssl-dev && rm -rf /var/lib/apt/lists/*;

COPY . /watcher

WORKDIR /watcher

RUN pip install --no-cache-dir .

CMD ["kube-log-watcher"]
