FROM python:stretch
LABEL maintainer="txt3rob@gmail.com"

# update
RUN apt-get update && apt-get install --no-install-recommends locales git wget nano -y && rm -rf /var/lib/apt/lists/*;

# Set default locale for the environment
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

RUN pip install --no-cache-dir git+https://github.com/tijme/angularjs-csti-scanner.git



CMD ["/bin/bash"]
