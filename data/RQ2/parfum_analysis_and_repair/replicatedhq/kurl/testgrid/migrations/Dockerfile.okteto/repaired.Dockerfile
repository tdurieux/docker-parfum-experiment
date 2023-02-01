FROM schemahero/schemahero:0.13.0-alpha.1 as schemahero
RUN mkdir -p /home/schemahero
WORKDIR /home/schemahero

USER root
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
USER schemahero

COPY tables tables
