FROM ignitehq/cli:0.20.4

EXPOSE 1318
EXPOSE 26658
EXPOSE 26659
EXPOSE 9092
EXPOSE 4500

WORKDIR .
COPY --chown=tendermint:tendermint . .

RUN chmod +x ./docker-run.sh

RUN ignite chain build
#RUN ignite chain init
#RUN python3 ./scripts/migrate_with_data.py ./blockchain-data/exported_genesis.json ~/.Cardchain/config/genesis.json

ENTRYPOINT ./docker-run.sh