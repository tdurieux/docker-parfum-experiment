FROM python
MAINTAINER Steve Neuharth <steve@aethereal.io>
RUN apt-get update && apt-get upgrade -y && pip install --no-cache-dir awscli ansi2html
ADD prowler* /usr/local/bin/
