FROM rocm/tensorflow:latest

ARG bazel_bin_url="https://github.com/bazelbuild/bazel/releases/download/3.7.2/bazel-3.7.2-linux-x86_64"

RUN echo ${bazel_bin_url}
RUN curl -f -L ${bazel_bin_url} -o /usr/local/bin/bazel \
    && chmod +x /usr/local/bin/bazel \
    && bazel

# This is a temporary workaround to fix Out-Of-Memory errors we are running into with XLA perf tests
# By default, HIP runtime "hides" 256MB from the TF Runtime, but with recent changes (update to ROCm2.3, dynamic loading of roc* libs, et al)
# it seems that we need to up the threshold slightly to 320MB
ENV HIP_HIDDEN_FREE_MEM=320

RUN wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb && dpkg -i erlang-solutions_2.0_all.deb && \
    apt-get update && \
    apt-get install -y --no-install-recommends esl-erlang && \
    apt-get install -y --no-install-recommends elixir && \
    rm erlang-solutions_2.0_all.deb && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends locales ca-certificates gdb && rm -rf /var/lib/apt/lists/*;

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN echo $LANG UTF-8 > /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=$LANG

RUN mix local.hex --force

ENV LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu:${LD_LIBRARY_PATH}"

ENV ROCM_PATH="/opt/rocm-3.9.0"