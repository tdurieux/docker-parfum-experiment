ARG PLATFORM
FROM registry.sean.farm/${PLATFORM}-builder as stage
WORKDIR /work/build
COPY . .
RUN make debian
RUN ls -ls /work

FROM scratch AS export
ARG PLATFORM
COPY --from=stage /work/*.deb ./${PLATFORM}/