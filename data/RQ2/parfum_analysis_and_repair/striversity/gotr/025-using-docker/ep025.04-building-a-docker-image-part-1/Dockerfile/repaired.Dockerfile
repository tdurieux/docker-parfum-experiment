FROM ubuntu

RUN echo "Hello, World!"

RUN apt update && apt dist-upgrade -y && apt install --no-install-recommends -y tree && rm -rf /var/lib/apt/lists/*;

WORKDIR /root

RUN mkdir a b overlay