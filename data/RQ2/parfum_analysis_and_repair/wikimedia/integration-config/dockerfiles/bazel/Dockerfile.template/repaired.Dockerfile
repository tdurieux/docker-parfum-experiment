# Docker image with bazel

FROM {{ "java8" | image_tag }}

USER root

# We get bazel from upstream
COPY bazel.gpg /etc/apt/trusted.gpg.d/bazel-release.gpg
RUN echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" \
    | tee /etc/apt/sources.list.d/bazel.list

RUN {{ "bazel=3.7.0" | apt_install }}

# For outputUserRoot / outputBase
RUN install --owner=nobody --group=nogroup --directory /var/local/bazel
COPY bazel /usr/local/bin/bazel
COPY bazelrc /var/local/bazel/bazelrc

USER nobody
# In addition to showing the actual Bazel version at build time, that also
# triggers extraction of the Bazel installation under outputUserRoot. That
# saves time on future invocations.