FROM nimlang/nim:0.18.0-ubuntu as build

WORKDIR /usr/src/app
COPY . /usr/src/app

RUN nimble install --depsOnly --accept \
    && nim c --threads:on -r tests/test1.nim \
    && nim c -d:release --threads:on --opt:size src/smalte.nim

FROM ubuntu:18.04
COPY --from=build /usr/src/app/src/smalte /app/smalte

WORKDIR /app

CMD ["/app/smalte"]
