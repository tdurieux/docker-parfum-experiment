FROM python:3-slim
RUN pip install --no-cache-dir urlchecker==0.0.28
CMD [ "/bin/bash" ]
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    --no-install-recommends curl git gnupg2 && \
    rm -rf /var/lib/apt/lists/*
RUN apt -y --no-install-recommends install curl dirmngr apt-transport-https ca-certificates \
    && curl -f -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get -y --no-install-recommends install nodejs \
    && rm -rf /var/lib/apt/lists/*
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y yarn \
    && rm -rf /var/lib/apt/lists/*
RUN yarn global add netlify-cli && yarn cache clean;
ENV HUGO_VERSION=0.96.0
RUN curl -fSL -O "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.deb" \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y /hugo_extended_${HUGO_VERSION}_Linux-64bit.deb \
    && rm /hugo_extended_${HUGO_VERSION}_Linux-64bit.deb && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir https://github.com/bilke/nb2hugo/archive/e27dc02df2be1ce19e4a6f52d197c2e2a6ca520c.zip
