FROM python:3.8.1-slim-buster

USER root
ENV HOME="/opt/whispers"
RUN useradd --home-dir $HOME --shell /bin/false user

WORKDIR $HOME
COPY . $HOME/
RUN apt update \
    && apt install --no-install-recommends -y build-essential python3-lxml python3-yaml \
    && apt clean \
    && make install \
    && chown -R user:user $HOME \
    && whispers -v && rm -rf /var/lib/apt/lists/*;

USER user
ENTRYPOINT [ "whispers" ]
