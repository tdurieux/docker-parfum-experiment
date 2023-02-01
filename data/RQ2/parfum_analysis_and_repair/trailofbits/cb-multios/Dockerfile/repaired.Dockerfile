FROM ubuntu:18.04

RUN apt update \
  && apt -y upgrade \
  && apt install --no-install-recommends -y build-essential libc6-dev libc6-dev-i386 \
    gcc-multilib g++-multilib clang python python-pip cmake && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir xlsxwriter pycrypto defusedxml pyyaml matplotlib

WORKDIR /cb-multios
COPY . ./

RUN ["/bin/bash", "./build.sh"]

ENTRYPOINT "/bin/bash"
