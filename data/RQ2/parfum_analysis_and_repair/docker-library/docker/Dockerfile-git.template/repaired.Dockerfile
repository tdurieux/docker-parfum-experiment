FROM docker:{{ env.version }}

RUN apk add --no-cache git