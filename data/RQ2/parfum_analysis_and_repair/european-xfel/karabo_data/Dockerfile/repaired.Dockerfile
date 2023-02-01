# ubuntu:latest seems to be LTS, i.e. 16.04 at the moment
FROM ubuntu:latest
RUN apt-get update -y && apt-get install --no-install-recommends -y python3 python3-pip git && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip
# use /io to mount host file system later
RUN mkdir /io
WORKDIR /io
