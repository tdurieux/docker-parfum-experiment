# https://docs.docker.com/engine/userguide/eng-image/multistage-build/
FROM gobuffalo/buffalo:{{.opts.Version}} as builder

RUN mkdir {{.opts.App.PackagePkg}}
WORKDIR {{.opts.App.PackagePkg}}

{{if .opts.App.WithWebpack -}}
# this will cache the npm install step, unless package.json changes
ADD package.json .
{{if .opts.App.WithYarn -}}
ADD yarn.lock .
RUN yarn install --no-progress && yarn cache clean;
{{else -}}
RUN npm install --no-progress && npm cache clean --force;
{{end -}}
{{end -}}

ADD . .
RUN buffalo build --static -o /bin/app

FROM alpine
RUN apk add --no-cache bash
RUN apk add --no-cache ca-certificates

WORKDIR /bin/

COPY --from=builder /bin/app .

# Uncomment to run the binary in "production" mode:
# ENV GO_ENV=production

# Bind the app to 0.0.0.0 so it can be seen from outside the container
ENV ADDR=0.0.0.0

EXPOSE 3000

# Uncomment to run the migrations before running the binary:
# CMD /bin/app migrate; /bin/app
CMD exec /bin/app
