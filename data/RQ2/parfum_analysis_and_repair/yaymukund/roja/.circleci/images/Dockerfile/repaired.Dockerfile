FROM cimg/rust:1.49
USER root
RUN apt-get update \
  && apt-get install --no-install-recommends -y \
    libmpv-dev \
    libsqlite3-dev && rm -rf /var/lib/apt/lists/*;
USER circleci
