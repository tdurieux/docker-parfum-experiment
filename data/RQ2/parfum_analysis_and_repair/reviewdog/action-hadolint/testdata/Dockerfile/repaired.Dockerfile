FROM ubuntu

RUN apt-get install --no-install-recommends -y jq && rm -rf /var/lib/apt/lists/*;

RUN LANGUAGE= nl
RUN cd /tmp && echo "hello!"
