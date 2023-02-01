FROM                ubuntu:14.04
MAINTAINER          Dmitry Orlov <me@mosquito.su>

RUN apt-get update && \
					apt-get install --no-install-recommends -y python-pip python-dev git && \
					apt-get clean && rm -rf /var/lib/apt/lists/*;

ADD                 . /tmp/build/
ADD                 autorestart.sh /usr/local/bin/autorestart.sh
RUN pip install --no-cache-dir --upgrade --pre /tmp/build && rm -fr /tmp/build

ENTRYPOINT          ["/usr/local/bin/lumper"]
