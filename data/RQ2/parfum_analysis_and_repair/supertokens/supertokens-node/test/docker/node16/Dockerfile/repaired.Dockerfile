FROM rishabhpoddar/supertokens_core_testing

RUN curl -f -sL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh

RUN chmod +x nodesource_setup.sh

RUN ./nodesource_setup.sh

RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;