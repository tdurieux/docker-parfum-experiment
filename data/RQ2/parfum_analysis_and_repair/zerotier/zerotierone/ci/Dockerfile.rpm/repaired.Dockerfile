ARG PLATFORM
FROM registry.sean.farm/${PLATFORM}-builder as stage
WORKDIR /root/rpmbuild/BUILD
COPY . .
RUN make redhat

FROM scratch AS export
ARG PLATFORM
COPY --from=stage /root/rpmbuild/RPMS/*/*.rpm ./${PLATFORM}/