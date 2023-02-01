FROM debian:sid
MAINTAINER Kacper Kowalik "xarthius.kk@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -qy wget && \
    apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

# add a user
RUN useradd -D --shell=/bin/bash && \
    useradd -m ytuser && \
    echo "ytuser:secret" | chpasswd

WORKDIR /home/ytuser
RUN wget https://bitbucket.org/yt_analysis/yt/raw/tip/doc/install_script.sh && \
    sed -i -e '/^MAKE_PROCS=/ s/""/"-j4"/' install_script.sh

RUN apt-get install --no-install-recommends -qy `grep -oP '(?<=apt-get install ).*?(?="|$)' install_script.sh` && rm -rf /var/lib/apt/lists/*;

USER ytuser
RUN echo "" | bash install_script.sh
