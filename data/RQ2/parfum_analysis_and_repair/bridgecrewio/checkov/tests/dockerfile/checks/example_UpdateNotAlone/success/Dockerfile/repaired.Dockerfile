FROM base

RUN apt-get update \
 && apt-get install -y --no-install-recommends foo \
 && echo gooo && rm -rf /var/lib/apt/lists/*;

RUN apk update \
 && apk add --no-cache suuu looo

RUN apk --update --no-cache add moo
