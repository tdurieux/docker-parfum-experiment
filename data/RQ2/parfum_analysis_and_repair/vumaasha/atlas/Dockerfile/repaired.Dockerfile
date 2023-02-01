# reference: https://hub.docker.com/_/ubuntu/
FROM ubuntu:latest

# Adds metadata to the image as a key value pair example LABEL version="1.0"
LABEL maintainer="Girish Shanmugam <s.girishshanmugam@gmail.com>"


# install Ubuntu dependencies and python image
RUN apt-get update \
  && apt-get install --no-install-recommends -y python3-pip python3-dev git \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --no-cache-dir --upgrade pip && rm -rf /var/lib/apt/lists/*;


# Clone git repository and install requirements
RUN git clone https://github.com/vumaasha/Atlas.git \
	&& pip3 install --no-cache-dir -r Atlas/models/product_categorization/requirements.txt
