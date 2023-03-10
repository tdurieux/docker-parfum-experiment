FROM scratch

ARG binaries_location=dist/linux

COPY $binaries_location/tfchaind /tfchaind
COPY $binaries_location/tfchainc /tfchainc
COPY $binaries_location/bridged /bridged

EXPOSE 23112

ENTRYPOINT ["/tfchaind"]