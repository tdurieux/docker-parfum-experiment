FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir requests
ADD . /src
WORKDIR /src
ENTRYPOINT ["python3"]
