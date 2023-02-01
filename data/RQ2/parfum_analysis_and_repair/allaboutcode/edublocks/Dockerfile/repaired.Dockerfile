FROM ubuntu:16.04
WORKDIR /var/edublocks
EXPOSE 8081
RUN apt-get update && \
    apt-get install --no-install-recommends -y curl python python3 python3-pip build-essential && \
    curl -f -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get update && \
    apt-get install --no-install-recommends -y nodejs && \
    npm -g i yarn node-gyp && \
    pip3 install --no-cache-dir 'ipython==6.0.0' && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

CMD [ "./tools/dev-start.sh" ]
