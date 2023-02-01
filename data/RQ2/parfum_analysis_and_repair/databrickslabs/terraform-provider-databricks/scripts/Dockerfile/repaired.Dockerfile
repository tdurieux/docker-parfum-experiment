FROM hashicorp/terraform:latest
RUN apk add --no-cache jq \
    && apk add --no-cache bash \
    && apk add --no-cache go \
    && apk add --no-cache python3 \
    && apk add --no-cache make \
    && go install gotest.tools/gotestsum@latest \
    && go install honnef.co/go/tools/cmd/staticcheck@latest

RUN mkdir /src \
    && ln -s /root/go/bin/gotestsum /bin/gotestsum \
    && ln -s /usr/bin/python3 /bin/python

WORKDIR /src
COPY . .

RUN make install

ENTRYPOINT [ "/src/scripts/it.sh" ]
