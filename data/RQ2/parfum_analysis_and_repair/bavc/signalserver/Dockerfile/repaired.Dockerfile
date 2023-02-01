FROM django:onbuild
RUN mkdir -p /var/signalserver/files
RUN mkdir -p /var/signalserver/files/policies
RUN useradd -ms /bin/bash signalserversadmin
RUN curl -f -sL https://deb.nodesource.com/setup_6.x | bash && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install -g bower && npm cache clean --force;
RUN cd frontend && bower install --allow-root
