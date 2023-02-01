FROM dart:stable

RUN dart --disable-analytics

RUN apt-get update && apt-get install --no-install-recommends -y \
    cmake \
    g++ \
    libgnutls28-dev \
    uuid-dev && rm -rf /var/lib/apt/lists/*;

# toc: https://taskwarrior.org/docs/taskserver/setup.html

# 2.1: Installation;
# https://taskwarrior.org/docs/taskserver/git.html

RUN curl -f -O https://taskwarrior.org/download/taskd-1.1.0.tar.gz \
    && tar xzf taskd-1.1.0.tar.gz \
    && cd taskd-1.1.0 \
    && cmake . \
    && make \
    && make install \
    && cd .. \
    && rm -r taskd-1.1.0 && rm taskd-1.1.0.tar.gz

RUN curl -f -O https://taskwarrior.org/download/task-2.6.2.tar.gz \
    && tar xzf task-2.6.2.tar.gz \
    && cd task-2.6.2 \
    && cmake -DCMAKE_BUILD_TYPE=release . \
    && make \
    && make install \
    && cd .. \
    && rm -r task-2.6.2 && rm task-2.6.2.tar.gz

RUN apt-get install --no-install-recommends lcov -y && rm -rf /var/lib/apt/lists/*;

ADD taskc/pubspec.yaml taskc/pubspec.yaml
ADD taskj/pubspec.yaml taskj/pubspec.yaml
ADD taskw/pubspec.yaml taskw/pubspec.yaml

RUN dart pub get -C taskc
RUN dart pub get -C taskj
RUN dart pub get -C taskw

RUN dart pub global activate dlcov
