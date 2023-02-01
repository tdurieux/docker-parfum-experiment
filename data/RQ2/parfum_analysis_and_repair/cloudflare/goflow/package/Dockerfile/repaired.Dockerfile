FROM ruby

RUN apt-get update && \
    apt-get install --no-install-recommends -y git make rpm golang && \
    gem install fpm && rm -rf /var/lib/apt/lists/*;

WORKDIR /work

ENTRYPOINT [ "/bin/bash" ]
