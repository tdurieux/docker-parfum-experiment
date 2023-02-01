#kudobuilder/flink-submission:1.7
FROM flink:1.7
COPY --from=bitnami/kubectl:1.13 /opt/bitnami/kubectl/bin/kubectl /usr/local/bin/kubectl

RUN apt-get update && apt-get install --no-install-recommends -y jq && rm -rf /var/lib/apt/lists/*;

ADD submit.sh .
ADD shutdown.sh .

ENTRYPOINT [ "./submit.sh" ]
