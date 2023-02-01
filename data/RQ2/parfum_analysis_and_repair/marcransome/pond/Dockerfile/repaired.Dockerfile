FROM ubuntu:latest

ENV TIMEZONE=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && \
    echo $TIMEZONE > /etc/timezone

RUN apt update && \
    apt install --no-install-recommends -y software-properties-common && \
    apt-add-repository -y ppa:fish-shell/release-3 && \
    apt update && \
    apt install --no-install-recommends -y fish && rm -rf /var/lib/apt/lists/*;

RUN apt install --no-install-recommends -y npm && \
    npm install -g tap-diff && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

RUN apt install --no-install-recommends -y git curl vim && rm -rf /var/lib/apt/lists/*;

RUN /usr/bin/fish -c "curl -sL git.io/fisher | source; and fisher install jorgebucaran/{fisher,fishtape}"

ENTRYPOINT ["/usr/bin/fish"]
