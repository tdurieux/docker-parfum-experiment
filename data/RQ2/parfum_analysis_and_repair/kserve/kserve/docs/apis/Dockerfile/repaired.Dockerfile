FROM golang:1.17

RUN apt-get update && apt-get -y upgrade && apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/ahmetb/gen-crd-api-reference-docs

WORKDIR gen-crd-api-reference-docs

RUN go build

VOLUME /go/gen-crd-api-reference-docs/apidocs

ENTRYPOINT ["./gen-crd-api-reference-docs"]
CMD ["-config", "./example-config.json", "-api-dir", "../src/github.com/kubeflow/kfserving/pkg/apis/serving/v1beta1", "-out-file", "./apidocs/v1beta1/README.md"]
