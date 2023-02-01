FROM bitnami/kubectl:1.21

USER root

RUN apt-get update && apt-get -y --no-install-recommends install uuid-runtime wget make && rm -rf /var/lib/apt/lists/*;

WORKDIR /blah

ENV KUBECONFIG=/blah/kubeconfig

COPY . .

RUN chmod +x setup-and-run.sh

ENTRYPOINT [ "/bin/bash" ]

CMD ["./setup-and-run.sh"]