FROM cimg/ruby:2.7.5-browsers

USER root

RUN apt-get update && apt-get install --no-install-recommends -y \
  default-mysql-client \
  libprotobuf-dev \
  protobuf-compiler && rm -rf /var/lib/apt/lists/*;

USER circleci
