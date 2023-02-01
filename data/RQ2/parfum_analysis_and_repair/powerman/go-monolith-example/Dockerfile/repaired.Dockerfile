FROM alpine:3.13

LABEL org.opencontainers.image.source="https://github.com/powerman/go-monolith-example"

WORKDIR /app

HEALTHCHECK CMD [ wget -q -O - https://$HOSTNAME:17000/health-check || exit 1]


COPY . .

ENTRYPOINT [ "bin/mono" ]

CMD [ "serve" ]
