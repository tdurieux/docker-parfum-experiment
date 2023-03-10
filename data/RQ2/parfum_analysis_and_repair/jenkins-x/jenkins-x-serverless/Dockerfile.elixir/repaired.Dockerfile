FROM jenkinsxio/jenkins-filerunner:0.1.49

RUN \
  echo "deb http://packages.erlang-solutions.com/debian stretch contrib" >> /etc/apt/sources.list

RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends --allow-unauthenticated --assume-yes esl-erlang elixir && rm -rf /var/lib/apt/lists/*;

# jx
ENV JX_VERSION 2.0.835
RUN curl -Lf https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz | tar xzv && \
  mv jx /usr/bin/
