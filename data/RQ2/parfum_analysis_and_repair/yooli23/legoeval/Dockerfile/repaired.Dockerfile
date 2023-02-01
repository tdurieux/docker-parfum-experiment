FROM node

COPY ./app/requirements.txt .

RUN apt-get update -y \
    && apt-get install --no-install-recommends -y \
    python3 \
    python3-pip \
    apt-utils \
    curl \
    git \
    wget \
    && pip3 install --no-cache-dir --upgrade pip \
    && pip3 install --no-cache-dir -r requirements.txt && rm -rf /var/lib/apt/lists/*;

WORKDIR /root

CMD ["/bin/bash"]

