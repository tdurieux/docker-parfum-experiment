# https://docs.docker.com/engine/userguide/eng-image/multistage-build/
FROM gobuffalo/buffalo:development as builder

RUN mkdir -p $GOPATH/src/github.com/gobuffalo/toolkit
WORKDIR $GOPATH/src/github.com/gobuffalo/toolkit

ENV GO111MODULE=on
# this will cache the npm install step, unless package.json changes
ADD package.json .
ADD yarn.lock .
RUN yarn install --no-progress && yarn cache clean;
ADD . .
RUN buffalo build --static -o /bin/app --skip-template-validation

FROM alpine
RUN apk add --no-cache bash
RUN apk add --no-cache curl
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
