ARG INTERCODE_TAG
FROM ghcr.io/neinteractiveliterature/intercode:${INTERCODE_TAG}
CMD bundle exec shoryuken --rails -C config/shoryuken.yml