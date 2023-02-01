FROM ubuntu:14.04

RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y python && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt/brokenbox

COPY ./broken_box.py ./

CMD ["python", "./broken_box.py"]
