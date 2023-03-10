FROM bernddoser/docker-devel-cpp:ubuntu-16.04

LABEL maintainer="Bernd Doser <bernd.doser@braintwister.eu>"

RUN apt-get update \
  && apt-get install --no-install-recommends -y apt-transport-https \
                        ca-certificates \
                        curl \
                        software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

RUN add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

RUN apt-get update \
  && apt-get install --no-install-recommends -y docker-ce=17.12.0~ce-0~ubuntu && rm -rf /var/lib/apt/lists/*;
