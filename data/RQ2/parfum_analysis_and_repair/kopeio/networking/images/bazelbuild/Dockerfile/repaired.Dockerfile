FROM java:8-jdk

RUN \
  apt-get update && apt-get upgrade --yes && \
  apt-get install --no-install-recommends -y curl g++ zlib1g-dev bash-completion make && \
  apt-get clean && rm -rf /var/lib/apt/lists/*


RUN \
  curl -f -L https://github.com/bazelbuild/bazel/releases/download/0.4.4/bazel_0.4.4-linux-x86_64.deb -o /tmp/bazel.deb && \
  dpkg -i /tmp/bazel.deb && \
  rm /tmp/bazel.deb

WORKDIR /src

CMD ["/usr/bin/bazel"]

