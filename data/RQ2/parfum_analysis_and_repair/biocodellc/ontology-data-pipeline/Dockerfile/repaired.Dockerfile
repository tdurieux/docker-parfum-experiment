### 1. Get Linux
FROM alpine:3.10.9

### 2. Get Java via the package manager
RUN apk update \
&& apk upgrade \
&& apk add --no-cache bash \
&& apk add --no-cache --virtual=build-dependencies unzip \
&& apk add --no-cache curl \
&& apk add --no-cache openjdk11-jre

### 3. Get Python, PIP
RUN apk add --no-cache make automake gcc g++ subversion libxml2-dev libxslt-dev python3-dev \
&& python3 -m ensurepip \
&& pip3 install --no-cache-dir --upgrade pip setuptools \
&& rm -r /usr/lib/python*/ensurepip && \
if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
rm -r /root/.cache

WORKDIR /app
COPY . /app

# Add ROBOT from external source. We do not save it as part of local distribution
# since this is a large jar file
ADD https://github.com/ontodev/robot/releases/download/v1.8.1/robot.jar /app/lib/

RUN pip install --no-cache-dir --trusted-host pypi.python.org -r requirements.txt
CMD [ "python", "./pipeline.py" ]

