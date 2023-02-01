FROM mcr.microsoft.com/dotnet/core/aspnet:2.2.5

WORKDIR /root

RUN    echo deb http://cloudfront.debian.net/debian testing main >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y \
            git \
            bpfcc-tools \
            lttng-tools \
            liblttng-ust-dev \
            procps \
            lldb \
    && rm -rf /var/lib/apt/lists/* \
    && git clone --depth=1 https://github.com/BrendanGregg/FlameGraph \
    && curl -OL https://aka.ms/perfcollect \
    && chmod +x ./perfcollect

ADD setup.sh \
    setup.4.15.sh \
    calc-offsets.py \
    netcore-bcc-trace.py \
    ./

RUN chmod +x setup.sh setup.4.15.sh