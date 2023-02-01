FROM easyckan/ckan:2.6

USER root

# Additional tools
RUN apt-get update && \
    apt-get install --no-install-recommends -y wget curl unzip zip htop fish-dbg libfontconfig && \
    curl -f -sSL https://deb.nodesource.com/setup_6.x | sh && \
    apt-get install --no-install-recommends -y nodejs && \
    npm install -g mocha-phantomjs@3.5.0 phantomjs@1.9.8 && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/lib/ckan

ADD ./.bashrc /usr/lib/ckan/.bashrc
RUN chown 5000.5000 /usr/lib/ckan/.bashrc

USER ckan

#ENTRYPOINT ["bash"]