from mongo:4.4

COPY scripts/startMongo.sh /startMongo
COPY scripts/wait-for.sh /wait-for.sh

CMD /startMongo