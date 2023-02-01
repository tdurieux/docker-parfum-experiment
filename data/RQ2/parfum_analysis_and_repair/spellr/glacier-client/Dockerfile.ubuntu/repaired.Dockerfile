FROM ubuntu
RUN apt update && apt install --no-install-recommends -y python3.6 python3-pip ruby ruby-dev rubygems build-essential && rm -rf /var/lib/apt/lists/*;
RUN gem install --no-document fpm

RUN mkdir /glacier
WORKDIR /glacier

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

COPY src/ src/
RUN fbs freeze
RUN fbs installer