FROM cloudiator/livy-server

RUN apt-get install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;