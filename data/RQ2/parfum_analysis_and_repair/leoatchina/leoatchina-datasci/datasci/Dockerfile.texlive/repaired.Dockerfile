FROM leoatchina/datasci:latest
# texlive
RUN cd /tmp && \
    wget https://github.com/jgm/pandoc/releases/download/2.2.3.2/pandoc-2.2.3.2-1-amd64.deb && \
    dpkg -i pandoc-2.2.3.2-1-amd64.deb && \
    apt-get update -y && \
    apt-get install --no-install-recommends texlive-full -y && \
    apt-get autoremove && apt-get clean && apt-get purge && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
