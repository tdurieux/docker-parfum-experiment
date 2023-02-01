FROM ubuntu:16.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
&& apt-get upgrade -y
RUN apt-get install --no-install-recommends -y python3 \
&& apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir Flask-API \
&& pip3 install --no-cache-dir flask_cors \
&& pip3 install --no-cache-dir requests

COPY . /app
WORKDIR /app
ENTRYPOINT ["python3"]
CMD ["app.py"]
