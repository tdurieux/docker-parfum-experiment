from ubuntu:20.04
MAINTAINER cb-developer-network@vmware.com

COPY . /app
WORKDIR /app

RUN apt-get update
RUN apt-get install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install --no-cache-dir .
