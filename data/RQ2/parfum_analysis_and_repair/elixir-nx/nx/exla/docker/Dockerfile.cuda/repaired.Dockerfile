FROM nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04
ARG bazel_bin_url="https://github.com/bazelbuild/bazel/releases/download/3.7.2/bazel-3.7.2-linux-x86_64"

WORKDIR /etc/apt/sources.list.d
RUN rm cuda.list nvidia-ml.list
WORKDIR /
RUN apt-get update && apt-get install -y --no-install-recommends wget curl git locales python3 python3-pip ca-certificates gdb && rm -rf /var/lib/apt/lists/*;
RUN echo ${bazel_bin_url}
RUN curl -f -L ${bazel_bin_url} -o /usr/local/bin/bazel \
    && chmod +x /usr/local/bin/bazel \
    && bazel

RUN wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb && dpkg -i erlang-solutions_2.0_all.deb && \
    apt-get update && \
    apt-get install -y --no-install-recommends esl-erlang && \
    apt-get install -y --no-install-recommends elixir && \
    rm erlang-solutions_2.0_all.deb && rm -rf /var/lib/apt/lists/*;

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN echo $LANG UTF-8 > /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=$LANG

RUN mix local.hex --force

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN pip3 install --no-cache-dir numpy
ENV LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu:${LD_LIBRARY_PATH}"
