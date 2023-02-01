FROM       eudat-b2handle

RUN        apt-get update && apt-get install -y --no-install-recommends \
           make \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

RUN        easy_install pip
RUN pip install --no-cache-dir \
           sphinx \
           sphinxjp.themes.bizstyle

VOLUME     /opt/B2HANDLE/docs

WORKDIR    /opt/B2HANDLE/docs

ENTRYPOINT ["make"]

CMD        ["help"]
