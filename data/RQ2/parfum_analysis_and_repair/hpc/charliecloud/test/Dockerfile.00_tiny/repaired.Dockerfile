# Minimal image useful for later tests.

# ch-test-scope: quick

FROM alpine:3.9

# For testing that permissions are retained on export (issue #1241). See FAQ
# for why these aren't 7777.