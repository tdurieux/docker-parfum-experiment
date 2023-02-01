# tryzeek
#
# VERSION               0.3

FROM node as web-builder
ADD web-ui/package.json web-ui/
ADD web-ui/package-lock.json web-ui/
RUN cd web-ui && npm install && npm cache clean --force;
ADD web-ui web-ui
RUN make -C web-ui

FROM      debian:buster-slim
MAINTAINER Justin Azoff <justin.azoff@gmail.com>

RUN apt-get update && \
    apt-get dist-upgrade -yq && \
    apt-get install --no-install-recommends -yq python-pip python-dev rsync && \
    rm /var/lib/apt/lists/*list -vf && \
    true && rm -rf /var/lib/apt/lists/*;

RUN mkdir /brostuff

ADD requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

ADD . /src
WORKDIR /src

# Add the webpack output to the web root
COPY --from=web-builder web-ui/build/ web-ui-build
RUN cp web-ui-build/*.* static/
RUN rsync -avP web-ui-build/static/ static/

RUN cd static/examples && ./pack.py
