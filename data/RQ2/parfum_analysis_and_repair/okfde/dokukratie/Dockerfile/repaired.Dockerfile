FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq -y update && apt-get install --no-install-recommends -y -qq python3-pip python3-icu git curl unzip libpq-dev && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -q pyicu
RUN curl -f "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
COPY . /opt/memorious
RUN pip3 install --no-cache-dir -q -e /opt/memorious
RUN pip3 install --no-cache-dir -r /opt/memorious/requirements-prod.txt
WORKDIR /opt/memorious
