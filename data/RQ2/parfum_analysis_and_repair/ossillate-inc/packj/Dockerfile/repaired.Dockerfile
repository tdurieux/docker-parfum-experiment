FROM ubuntu:20.04

WORKDIR /packj

RUN apt update -y && apt install --no-install-recommends -y python3 gcc python3-dev python3-pip ruby-full rubygems-integration musl-dev protobuf-compiler git ruby-full libmagic-dev && rm -rf /var/lib/apt/lists/*;
RUN gem install parser:3.0.0.0 google-protobuf:3.21.2 rubocop:1.31.1

COPY . .
RUN pip3 install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python3", "main.py"]
