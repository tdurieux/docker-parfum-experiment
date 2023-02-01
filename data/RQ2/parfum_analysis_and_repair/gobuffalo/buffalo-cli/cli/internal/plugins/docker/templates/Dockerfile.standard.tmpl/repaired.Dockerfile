FROM gobuffalo/buffalo:{{.BuffaloVersion}}

ENV GO111MODULE on
ENV GOPROXY http://proxy.golang.org

RUN mkdir -p /src/{{.Name}}
WORKDIR /src/{{.Name}}

{{if .WebPack -}}
# this will cache the npm install step, unless package.json changes
ADD package.json .
{{if eq "yarn" .Tool -}}
ADD yarn.lock .
RUN yarn install --no-progress && yarn cache clean;
{{else -}}
RUN npm install --no-progress && npm cache clean --force;
{{end -}}
{{end -}}

# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum
# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate our downloaded layer
RUN go mod download

ADD . .
RUN buffalo build --static -o /bin/app

# Uncomment to run the binary in "production" mode:
# ENV GO_ENV=production

# Bind the app to 0.0.0.0 so it can be seen from outside the container
ENV ADDR=0.0.0.0

EXPOSE 3000

# Uncomment to run the migrations before running the binary:
# CMD /bin/app migrate; /bin/app
CMD exec /bin/app
