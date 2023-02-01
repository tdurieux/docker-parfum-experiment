FROM launcher.gcr.io/google/debian9
RUN apt-get update
RUN apt-get install --no-install-recommends -y bash curl wget gnupg apt-transport-https apt-utils lsb-release && rm -rf /var/lib/apt/lists/*;
RUN wget -O - https://debian.neo4j.org/neotechnology.gpg.key | apt-key add -
RUN curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo 'deb https://debian.neo4j.com stable 3.5' | tee -a /etc/apt/sources.list.d/neo4j.list
RUN echo "deb http://packages.cloud.google.com/apt cloud-sdk-$(lsb_release -c -s) main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

RUN echo "neo4j-enterprise neo4j/question select I ACCEPT" | debconf-set-selections
RUN echo "neo4j-enterprise neo4j/license note" | debconf-set-selections

RUN apt-get update && apt-get install --no-install-recommends -y neo4j-enterprise=1:3.5.22 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y google-cloud-sdk unzip && rm -rf /var/lib/apt/lists/*;

RUN mkdir /data
ADD restore/restore.sh /scripts/restore.sh
RUN chmod +x /scripts/restore.sh

CMD ["/scripts/restore.sh"]
