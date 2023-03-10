FROM sovrin/dockerbase:rust-xenial-0.8.0
# TODO LABEL maintainer="Name <email-address>"

ARG PYTHON3_VERSION
ARG ANDROID_NDK_VERSION

# python3
ENV PYTHON3_VERSION=${PYTHON3_VERSION:-3.5}
RUN apt-get update && apt-get install -y --no-install-recommends \
        python${PYTHON3_VERSION} \
    && rm -rf /var/lib/apt/lists/*

# android ndk
ENV ANDROID_NDK_VERSION=${ANDROID_NDK_VERSION:-r16b}
COPY android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip /tmp/
COPY android-ndk-install /usr/local/bin/
RUN chmod +x /usr/local/bin/android-ndk-install

# TODO CMD ENTRYPOINT ...

ENV ANDROID_NDK_ENV_VERSION=0.2.0