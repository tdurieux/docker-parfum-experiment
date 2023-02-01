FROM ubuntu:20.04
USER root
RUN \
	apt update && \
    apt install --no-install-recommends -y nodejs && \
    apt install --no-install-recommends -y npm && \
RUN \
	apt -y update && \
    apt install --no-install-recommends -y build-essential python3-dev python3-pip python3-setuptools python3-wheel python3-cffi libcairo2 libpango-1.0-0 libpangocairo-1.0-0 libgdk-pixbuf2.0-0 libffi-dev shared-mime-info && \
    apt install --no-install-recommends -y weasyprint && \
    weasyprint --version && rm -rf /var/lib/apt/lists/*;
WORKDIR /usr/pdf




