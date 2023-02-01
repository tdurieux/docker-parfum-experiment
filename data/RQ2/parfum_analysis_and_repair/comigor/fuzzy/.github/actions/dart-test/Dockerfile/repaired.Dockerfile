FROM cirrusci/flutter:beta

USER root

RUN apt update && apt install --no-install-recommends -y jq && rm -rf /var/lib/apt/lists/*;

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]