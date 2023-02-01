FROM adamantium/flutter

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -q && \
    apt-get install -qy curl ca-certificates gnupg2 build-essential --no-install-recommends && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && \
    apt-get install --no-install-recommends -y wget && \
    apt-get install --no-install-recommends -y build-essential && \
    apt-get install --no-install-recommends -y zlib1g && \
    apt-get install -y --no-install-recommends zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN gpg2 --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
RUN curl -f -sSL https://get.rvm.io | bash -s
RUN /bin/bash -l -c ". /etc/profile.d/rvm.sh && rvm install 2.3.3"
RUN /bin/bash -l -c ". /etc/profile.d/rvm.sh && gem install pdd"

RUN apt-get install --no-install-recommends -y python-pip && \
    pip install --no-cache-dir firebase-admin && rm -rf /var/lib/apt/lists/*;
