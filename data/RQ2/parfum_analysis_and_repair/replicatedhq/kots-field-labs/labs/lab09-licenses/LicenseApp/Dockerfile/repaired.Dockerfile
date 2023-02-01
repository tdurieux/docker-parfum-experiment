FROM ubuntu:18.04

MAINTAINER Fernando Cremer "cremerfc@gmail.com"

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y python3-pip python3-dev && rm -rf /var/lib/apt/lists/*;

COPY ./Requirements.txt /Requirements.txt

WORKDIR /

RUN pip3 install --no-cache-dir -r Requirements.txt

COPY . /

ENTRYPOINT [ "python3" ]

CMD [ "app/app.py" ]