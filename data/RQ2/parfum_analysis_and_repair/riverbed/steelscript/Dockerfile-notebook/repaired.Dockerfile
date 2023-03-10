FROM riverbed/steelscript:latest
MAINTAINER Riverbed Technology

RUN set -ex \
        && pip install --no-cache-dir ipython jupyter

# Install Tini, a process runner
RUN wget --quiet https://github.com/krallin/tini/releases/download/v0.10.0/tini && \
    echo "1361527f39190a7338a0b434bd8c88ff7233ce7b9a4876f3315c22fce7eca1b0  *tini" | sha256sum -c - && \
    mv tini /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini

EXPOSE 8888
WORKDIR /root/steelscript-workspace

# Configure container startup
ENTRYPOINT ["tini", "--"]
CMD ["/usr/local/bin/jupyter", "notebook", "--no-browser", "--allow-root", "--ip=0.0.0.0"]
