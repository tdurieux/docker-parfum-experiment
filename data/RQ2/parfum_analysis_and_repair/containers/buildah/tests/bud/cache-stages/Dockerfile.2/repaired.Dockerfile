FROM alpine AS builder
RUN touch /tmpfile
FROM alpine AS base
COPY --from=builder /tmpfile /
RUN stat /tmpfile