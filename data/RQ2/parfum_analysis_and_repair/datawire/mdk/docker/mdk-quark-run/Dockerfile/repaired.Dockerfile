# Use standard quark run as the base
FROM datawire/quark-run

# Add a ton of crap so Twisted can be built...
RUN apk add --no-cache --update alpine-sdk libffi-dev openssl-dev
