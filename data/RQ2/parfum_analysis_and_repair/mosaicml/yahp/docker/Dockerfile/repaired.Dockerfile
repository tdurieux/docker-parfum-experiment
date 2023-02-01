FROM mosaicml/research:latest

WORKDIR /workspace
COPY . ./src/hparams
RUN pip install --no-cache-dir -e src/hparams
