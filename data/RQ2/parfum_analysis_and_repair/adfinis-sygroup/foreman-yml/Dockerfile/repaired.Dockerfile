FROM ubuntu:xenial

RUN apt-get update && apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /foreman-yml/configs
ADD . /foreman-yml
WORKDIR /foreman-yml
RUN pip install --no-cache-dir .
VOLUME /foreman-yml/configs
ENTRYPOINT ["foreman-yml"]
