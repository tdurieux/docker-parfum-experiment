# Dockerfile

# Author       : KasRoudra
# Github       : https://github.com/KasRoudra
# Messenger    : https://m.me/KasRoudra
# Email        : kasroudrakrd@gmail.com
# Date         : 25-08-2021
# Main Language: Python

# Download and import main images

# Operating system
FROM debian:10
# Main package
FROM python:3

# Author info
LABEL MAINTAINER="https://github.com/KasRoudra/pyphisher"

# Working directory
WORKDIR pyphisher/
# Add files
ADD . /pyphisher

# Installing other packages
RUN apt-get update
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y php && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean

# Main command
CMD ["python3", "pyphisher.py"]

## Wanna run it own? Try following commnads:

## "cd pyphisher", "docker build . -t pyphisher:1.0", "docker run --rm -it pyphisher:1.0"