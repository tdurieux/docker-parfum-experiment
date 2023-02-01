FROM ubuntu:12.04.5

# Because there is no package cache in the image, you need to run:
RUN apt-get update

# Install nodejs
RUN apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python-software-properties -y && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Install tty-table
RUN apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
RUN git clone https://www.github.com/tecfu/tty-table

WORKDIR /tty-table

# Manual Phantomjs install
RUN apt-get install --no-install-recommends wget -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends bzip2 -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libfontconfig1 -y && rm -rf /var/lib/apt/lists/*;
RUN cd /usr/local/share/
RUN wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.6-linux-x86_64.tar.bz2
RUN ls
RUN tar xjf phantomjs-1.9.6-linux-x86_64.tar.bz2 && rm phantomjs-1.9.6-linux-x86_64.tar.bz2
RUN rm -f phantomjs-1.9.6-linux-x86_64.tar.bz2
RUN ln -s phantomjs-1.9.6-linux-x86_64 phantomjs
RUN ln -s /usr/local/share/phantomjs/bin/phantomjs /usr/bin/phantomjs

#RUN npm uninstall -D grunt-mocha
#RUN npm i grunt-mocha@0.4.13
RUN npm install && npm cache clean --force;

# Run unit tests
RUN node -v
RUN npx mocha
