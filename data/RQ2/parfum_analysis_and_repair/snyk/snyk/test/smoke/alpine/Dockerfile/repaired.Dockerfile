FROM shellspec/shellspec:latest

COPY ./smoke/ /snyk/smoke/
COPY ./fixtures/ /snyk/fixtures/

RUN shellspec --version
RUN apk add --no-cache curl jq libgcc libstdc++

WORKDIR /snyk/smoke/

ENTRYPOINT [ "./alpine/entrypoint.sh" ]
