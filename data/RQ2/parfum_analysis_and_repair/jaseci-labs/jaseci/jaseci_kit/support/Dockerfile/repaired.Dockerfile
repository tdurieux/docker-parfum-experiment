FROM ubuntu:20.04
WORKDIR /
ENV DEBIAN_FRONTEND=noninteractive
ADD ./ /jaseci_kit/
RUN apt update && apt -y install --no-install-recommends python3.8 python3-pip python3-dev vim git build-essential g++ && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir /jaseci_kit
CMD ["echo", "Ready"]
