FROM tensorflow/tensorflow:devel

RUN apt-get install -y --no-install-recommends locales ca-certificates gdb && rm -rf /var/lib/apt/lists/*;

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN echo $LANG UTF-8 > /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=$LANG

RUN mix local.hex --force
