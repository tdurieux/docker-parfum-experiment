ARG VERSION=latest
FROM conjur:${VERSION}

RUN bundle --no-deployment --without ''