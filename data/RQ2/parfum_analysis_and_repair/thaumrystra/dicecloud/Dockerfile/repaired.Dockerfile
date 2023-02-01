FROM ubuntu:latest
RUN apt-get update --quiet \
    && apt-get install --no-install-recommends --quiet --yes \
    bsdtar \
    curl \
    git && rm -rf /var/lib/apt/lists/*;
RUN ln --symbolic --force $(which bsdtar) $(which tar)
RUN useradd --create-home --shell /bin/bash dicecloud
USER dicecloud
WORKDIR /home/dicecloud
RUN curl -f https://install.meteor.com/?release=1.8.0.2 | sh
ENV PATH="${PATH}:/home/dicecloud/.meteor"
COPY dev.sh ./dev.sh
ENTRYPOINT ./dev.sh