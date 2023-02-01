FROM golang:1.16-alpine AS build

ENV CGO_ENABLED=0

RUN apk add --no-cache \
      git \
      curl \
      make

RUN mkdir -p /out/usr/local/bin

ENV KUBELETMEIN $GOPATH/src/github.com/4armed/kubeletmein
RUN mkdir -p "$(dirname ${KUBELETMEIN})"
COPY . $KUBELETMEIN

WORKDIR $KUBELETMEIN
RUN make build-quick && cp ./kubeletmein /out/usr/local/bin/kubeletmein

WORKDIR /out
RUN curl -f -sL https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl -o usr/local/bin/kubectl && \
    chmod +x usr/local/bin/kubectl

FROM gcr.io/google.com/cloudsdktool/cloud-sdk:330.0.0
LABEL maintainer="Marc Wickenden <marc@4armed.com>"

COPY --from=build /out /

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -yq \
      groff \
      unzip && rm -rf /var/lib/apt/lists/*;

# AWS CLI
RUN curl -f "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
      unzip awscliv2.zip && \
      ./aws/install -i /usr/local/aws-cli -b /usr/local/bin && \
      rm -rf aws awscliv2.zip

CMD [ "kubeletmein" ]
