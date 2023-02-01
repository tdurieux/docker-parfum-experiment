ARG VERSION=latest
FROM connectedhomeip/chip-build:${VERSION}

# Bazel
RUN set -x \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -fy \
       curl gnupg \
    && curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --batch --dearmor > bazel.gpg \
    && mv bazel.gpg /etc/apt/trusted.gpg.d/ \
    && echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -fy \
       bazel \
    && : && rm -rf /var/lib/apt/lists/*;

# Docker
RUN set -x \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -fy \
       curl gnupg-agent apt-transport-https ca-certificates \
       software-properties-common \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && python3.8 `which add-apt-repository` \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -fy \
       docker-ce docker-ce-cli containerd.io \
    && : && rm -rf /var/lib/apt/lists/*;

# Other Cirque prereqs
RUN set -x \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -fy \
       sudo socat psmisc tigervnc-standalone-server xorg xauth \
       python3-pip python3-venv python3-setuptools libdbus-glib-1-dev \
       uuid-runtime libgirepository1.0-dev \
    && : && rm -rf /var/lib/apt/lists/*;

COPY requirements_nogrpc.txt /requirements.txt

RUN set -x \
    && pip3 install --no-cache-dir -r requirements.txt \
    && xinit -- /usr/bin/Xvnc \
    && :
