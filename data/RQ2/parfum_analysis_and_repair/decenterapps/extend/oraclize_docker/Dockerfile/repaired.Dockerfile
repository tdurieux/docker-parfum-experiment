FROM ubuntu:14.04
MAINTAINER Decenter "extend@decenter.com"

ADD send_request.py /

RUN apt-get update && apt-get -y --no-install-recommends install python-minimal && apt-get -y --no-install-recommends install python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir requests

CMD [ "python", "./send_request.py" ]