FROM debian:jessie

RUN apt-get update && apt-get install --no-install-recommends -y curl \
    libgtk2.0-0 \
    libX11-xcb-dev \
    libxtst6 \
    libxss1 \
    libgconf-2-4 \
    libnss3-dev \
    libasound2 && rm -rf /var/lib/apt/lists/*;

RUN mkdir /postman && cd /postman && \
    curl -f -o postman.tar.gz -O https://dl.pstmn.io/download/latest/linux64 && \
    tar xzf postman.tar.gz && rm postman.tar.gz

WORKDIR /postman/Postman/

ENTRYPOINT ["/postman/Postman/Postman"]