FROM ubuntu:20.04

ARG INFER_VERSION=v1.0.0

# build dependencies
RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install cppcheck git curl xz-utils && rm -rf /var/lib/apt/lists/*;

# install one-line-scan
RUN git clone https://github.com/awslabs/one-line-scan.git /opt/one-line-scan

# install infer
RUN curl -f -o /tmp/infer.tar.xz -sSL "https://github.com/facebook/infer/releases/download/${INFER_VERSION}/infer-linux64-${INFER_VERSION}.tar.xz"
RUN tar -C /opt -xJf /tmp/infer.tar.xz && rm /tmp/infer.tar.xz
RUN ln -s "/opt/infer-linux64-${INFER_VERSION}/bin/infer" /usr/local/bin/infer

CMD ["/opt/one-line-scan/one-line-cr-bot.sh", "-E", "infer", "-E", "cppcheck"]
