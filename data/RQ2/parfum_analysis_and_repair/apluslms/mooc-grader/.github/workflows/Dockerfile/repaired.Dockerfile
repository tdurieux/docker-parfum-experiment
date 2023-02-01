FROM ubuntu:latest

ARG GECKODRIVER_VERSION=0.30.0
ARG GECKODRIVER_FILE=geckodriver-v${GECKODRIVER_VERSION}-linux64.tar.gz
ARG GECKODRIVER_LINK=https://github.com/mozilla/geckodriver/releases/download/v${GECKODRIVER_VERSION}/$GECKODRIVER_FILE

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -y && apt install --no-install-recommends -y python3 python3-pip git gettext curl firefox && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel

# install python requirements
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
RUN rm requirements.txt

# install geckodriver for selenium
RUN curl -f -s -L $GECKODRIVER_LINK | tar -xz
RUN chmod +x geckodriver
RUN mv geckodriver /usr/bin/
