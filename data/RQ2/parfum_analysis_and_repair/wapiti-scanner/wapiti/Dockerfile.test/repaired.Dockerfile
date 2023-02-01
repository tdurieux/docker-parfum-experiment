FROM ubuntu:latest
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install --no-install-recommends ca-certificates -y && rm -rf /var/lib/apt/lists/*;
RUN update-ca-certificates
RUN apt-get install --no-install-recommends python3 python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install php8.1-cli php8.1-xml -y --no-install-recommends && rm -rf /var/lib/apt/lists/*;
RUN python3 -c "import sys; print(sys.version)"
RUN python3 -m pip install --upgrade pip
RUN pip3 install --no-cache-dir -U setuptools
RUN mkdir /usr/src/app && rm -rf /usr/src/app

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR /usr/src/app

COPY . .

RUN pip3 install --no-cache-dir .[sslyze]
CMD ["python3", "setup.py", "test", "-vv"]
