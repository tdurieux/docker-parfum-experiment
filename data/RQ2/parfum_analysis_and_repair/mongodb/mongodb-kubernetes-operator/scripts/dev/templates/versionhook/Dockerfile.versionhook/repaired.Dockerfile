ARG imagebase
FROM ${imagebase} as base

FROM busybox

COPY --from=base /version-upgrade-hook /version-upgrade-hook