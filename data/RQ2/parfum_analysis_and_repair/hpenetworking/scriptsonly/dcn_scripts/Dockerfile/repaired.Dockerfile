FROM ubuntu:latest
MAINTAINER Rick Kauffman "chewie@wookieware.com"
RUN apt-get update -y && apt-get install --no-install-recommends -y python-pip python-dev build-essential && rm -rf /var/lib/apt/lists/*;
COPY . /app
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt
ENTRYPOINT ["python"]
CMD ["views.py"]
