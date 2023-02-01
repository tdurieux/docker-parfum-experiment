FROM alpine:3.1
MAINTAINER Zach Kontoulis <z.kontoulis@gmail.com>

# Update
RUN apk add --no-cache --update python py-pip

COPY . /
# Install app dependencies
RUN pip install --no-cache-dir -r /requirements.txt

CMD ["python", "/updater.py"]

