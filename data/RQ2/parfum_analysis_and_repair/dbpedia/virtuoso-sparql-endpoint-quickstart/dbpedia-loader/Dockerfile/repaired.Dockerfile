FROM debian:jessie

LABEL org.aksw.dld=true org.aksw.dld.type="import" org.aksw.dld.require.store="virtuoso" org.aksw.dld.config="{volumes_from: [store]}"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y git virtuoso-opensource pigz pbzip2 && rm -rf /var/lib/apt/lists/*;

ADD import.sh /
RUN chmod +x /import.sh

ENTRYPOINT /bin/bash import.sh
