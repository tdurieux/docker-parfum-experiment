FROM alpine as build

FROM scratch
COPY --from=build / /
RUN touch cache-invalidating-difference
COPY --from=build / /