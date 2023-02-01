FROM golang:1.15

RUN apt update && apt install --no-install-recommends -y docker.io && apt install --no-install-recommends -y jq && rm -rf /var/lib/apt/lists/*;

RUN GO111MODULE="on" go get sigs.k8s.io/kind@v0.9.0

RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/v1.19.0/bin/linux/amd64/kubectl && chmod +x kubectl && cp kubectl /usr/bin/