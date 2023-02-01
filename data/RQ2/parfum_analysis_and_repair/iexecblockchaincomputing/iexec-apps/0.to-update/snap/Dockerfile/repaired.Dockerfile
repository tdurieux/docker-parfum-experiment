FROM mrmoor/esa-snap

RUN apt-get install -y --no-install-recommends unzip && rm -rf /var/lib/apt/lists/*;
COPY processDataset.sh processDataset.sh

RUN chmod +x processDataset.sh

ENTRYPOINT ["sh","-c","./processDataset.sh $@"]]
