FROM ubuntu:22.04
WORKDIR tmp
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt install --no-install-recommends nodejs npm -y && rm -rf /var/lib/apt/lists/*;
RUN npm install --global http-server && apt-get install --no-install-recommends -y mkdocs && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python3-pip -y && pip install --no-cache-dir mkdocs-material && pip install --no-cache-dir Pygments && rm -rf /var/lib/apt/lists/*;

COPY . /tmp
RUN mkdocs build

CMD ["sh","-c","http-server /tmp/site"]


