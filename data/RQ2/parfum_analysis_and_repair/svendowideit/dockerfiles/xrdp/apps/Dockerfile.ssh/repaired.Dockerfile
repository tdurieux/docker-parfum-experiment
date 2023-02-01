FROM appbase

RUN apt-get install --no-install-recommends -yq openssh-client && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["ssh"]
