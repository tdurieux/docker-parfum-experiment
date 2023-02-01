FROM ubuntu:21.10
ENV INSTALL_DIR=/opt/cyberark-conjur-cli
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
  apt-get install --no-install-recommends -y bash \
                    binutils \
                    build-essential \
                    curl \
                    git \
                    jq \
                    libffi-dev \
                    libssl-dev \
                    python3 \
                    python3-dev \
                    python3-pip \
                    zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p $INSTALL_DIR
WORKDIR $INSTALL_DIR

COPY ./requirements.txt $INSTALL_DIR/
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . $INSTALL_DIR
