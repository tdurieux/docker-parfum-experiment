# see: https://github.com/operator-framework/operator-registry/blob/master/docs/design/operator-bundle.md
FROM scratch

# the channel name we settled for is "${MAJOR}.${MINOR}"
# 1. trivial to crosscheck with OCP version we target
# 2. Z-stream friendly