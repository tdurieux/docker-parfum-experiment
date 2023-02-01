# ref12/azdevagent

# Get runtime container to copy dotnet binaries
FROM mcr.microsoft.com/dotnet/core/runtime:2.2 AS runtime

ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update \
&& apt-get install -y \
        ca-certificates \
        curl \
        jq \
        git \
        iputils-ping \
        libcurl3 
#        libicu55

WORKDIR /azp

# Inputs (environment variables)
ARG AZP_URL
ARG AZP_TOKEN

# Run install.h to get remaining dependencies
COPY ./install.sh .
RUN chmod +x install.sh
RUN ./install.sh

# Entrypoint is start.sh
COPY ./start.sh .
RUN chmod +x start.sh
CMD ["./start.sh"]