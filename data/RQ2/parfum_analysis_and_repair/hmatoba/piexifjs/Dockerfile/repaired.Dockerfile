FROM ubuntu

RUN apt-get update && \
    apt-get install --no-install-recommends -y nodejs && \
    apt-get install --no-install-recommends -y phantomjs && rm -rf /var/lib/apt/lists/*;

RUN mkdir /test/
ADD . /test/
WORKDIR /test/

ENTRYPOINT phantomjs phestum.js piexif.js && nodejs nodetest.js