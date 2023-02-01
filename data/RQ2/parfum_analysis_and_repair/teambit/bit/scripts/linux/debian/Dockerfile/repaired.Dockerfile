FROM debian
RUN apt-get update && apt-get install --no-install-recommends -y curl software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get -y --no-install-recommends install nano git nodejs ruby ruby-dev rubygems build-essential && rm -rf /var/lib/apt/lists/*;
RUN gem install --no-ri --no-rdoc fpm
RUN npm i -g pkg@4.4.6 && npm cache clean --force;
RUN sh -c "echo 'deb [trusted=true] https://bitsrc.jfrog.io/bitsrc/bit-deb all development' >> /etc/apt/sources.list"
CMD ["/bin/bash"]
