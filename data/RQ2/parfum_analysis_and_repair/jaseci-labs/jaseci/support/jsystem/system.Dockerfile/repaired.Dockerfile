FROM ubuntu:20.04
WORKDIR /
ENV DEBIAN_FRONTEND=noninteractive
COPY requirements.txt requirements.txt
RUN apt update; apt -y upgrade; apt -y --no-install-recommends install git; rm -rf /var/lib/apt/lists/*;
RUN apt -y install --no-install-recommends python3.8 python3-pip openjdk-8-jre vim; apt-get clean; rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -r requirements.txt;
CMD ["echo", "Ready"]
