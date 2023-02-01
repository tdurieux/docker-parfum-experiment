from ubuntu:18.04

RUN apt-get update
RUN apt-get -y --no-install-recommends install apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install curl gnupg2 && rm -rf /var/lib/apt/lists/*;
RUN curl -f -N -s https://bazel.build/bazel-release.pub.gpg | apt-key add -
RUN echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
RUN apt-get update
RUN apt-get -y --no-install-recommends install bazel=5.1.1 libfuse-dev libfuse2 git python pkg-config && rm -rf /var/lib/apt/lists/*;
RUN echo "build --jobs=2 --host_force_python=PY2 --remote_http_cache=https://storage.googleapis.com/colinmerkel-bazel-cache --google_credentials=/data/bazel-access.json" >> /etc/bazel.bazelrc
RUN echo "test --jobs=2 --host_force_python=PY2 --remote_http_cache=https://storage.googleapis.com/colinmerkel-bazel-cache --google_credentials=/data/bazel-access.json" >> /etc/bazel.bazelrc
RUN echo "run --jobs=2 --host_force_python=PY2 --remote_http_cache=https://storage.googleapis.com/colinmerkel-bazel-cache --google_credentials=/data/bazel-access.json" >>  /etc/bazel.bazelrc
RUN mkdir /root/.ssh
RUN echo "Host github.com" >> /root/.ssh/config
RUN echo "   StrictHostKeyChecking no" >> /root/.ssh/config
RUN git config --global user.email "weld@colinmerkel.xyz"
RUN git config --global user.name "weld-bot"
RUN mkdir /data
RUN bazel
# Install google cloud sdk
RUN curl -f https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz
RUN mkdir -p /usr/local/gcloud \
  && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
  && /usr/local/gcloud/google-cloud-sdk/install.sh && rm /tmp/google-cloud-sdk.tar.gz
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

