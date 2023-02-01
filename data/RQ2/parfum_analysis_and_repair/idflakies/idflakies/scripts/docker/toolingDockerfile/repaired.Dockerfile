# docker build -t toolingdetectorbase:latest - < toolingDockerfile

# Start from the base detect image
FROM detectorbase:latest

WORKDIR /home/idflakies
USER idflakies

## Install the tooling