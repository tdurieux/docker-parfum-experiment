FROM dockerlocktestaccount/busybox@sha256:dd97a3fe6d721c5cf03abac0f50e2848dc583f7c4e41bf39102ceb42edfd1808 AS base
COPY . .
FROM base AS final
ADD . .
FROM dockerlocktestaccount/ubuntu@sha256:2e70e9c81838224b5311970dbf7ed16802fbfe19e7a70b3cbfa3d7522aa285b4