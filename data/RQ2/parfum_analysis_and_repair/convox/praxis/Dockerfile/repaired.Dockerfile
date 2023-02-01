## convox:development

FROM convox/golang

ENV DEVELOPMENT=true

WORKDIR $GOPATH/src/github.com/convox/praxis

COPY . .

CMD ["rerun", "-watch", ".", "-build", "github.com/convox/praxis/cmd/rack"]

## convox:production