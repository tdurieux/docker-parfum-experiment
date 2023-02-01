ARG TERRAFORM_VERSION=0.12.29

FROM hashicorp/terraform:${TERRAFORM_VERSION}
RUN apk add --no-cache jq \
    && apk add --no-cache bash \
    && apk add --no-cache go \
    && apk add --no-cache python3 \
    && apk add --no-cache make \
    && go get gotest.tools/gotestsum

RUN mkdir /src \
    && ln -s /root/go/bin/gotestsum /bin/gotestsum \
    && ln -s /usr/bin/python3 /bin/python

WORKDIR /src
COPY . .

ENTRYPOINT [ "/src/scripts/run.sh" ]