FROM metabase/metabase
RUN apk add --no-cache jq && apk add --no-cache tmux
COPY init.sh .
COPY setup-mb-account.sh .
ENTRYPOINT []
