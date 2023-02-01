FROM base

RUN apt-get install --no-install-recommends -y libxml2 libxml2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential xml2 && rm -rf /var/lib/apt/lists/*;

ADD armagetronad-*.tbz /
ADD install.sh /install.sh
RUN /install.sh
ADD start-* /tron/

CMD ["/tron/start-ffa.sh"]
