FROM golang:1.16
WORKDIR /var/task
ENV HOME /root

# install nodejs and yarn
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - \
 && apt install --no-install-recommends -y nodejs \
 && npm install --global yarn && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;
