ARG LANGUAGE="default"

FROM chromedp/headless-shell as base

FROM base as default

FROM base as chinese
RUN apt update && \
    apt install --no-install-recommends -y ttf-wqy-zenhei && \
    apt install --no-install-recommends -y xfonts-intl-chinese wqy* && \
    apt autoclean && \
    rm -rf /var/lib/apt/lists/*

FROM ${LANGUAGE} as final

WORKDIR /data

COPY mdout /usr/local/bin

RUN mdout install theme -u https://github.com/JabinGP/mdout-theme-github/archive/0.1.1.zip -n github -k

ENTRYPOINT ["mdout"]