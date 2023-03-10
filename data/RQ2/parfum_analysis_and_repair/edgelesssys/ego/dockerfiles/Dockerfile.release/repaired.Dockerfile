FROM ghcr.io/edgelesssys/edgelessrt-dev AS build

COPY ego_*_amd64.deb /
RUN apt install --no-install-recommends -y ./ego_*_amd64.deb && rm -rf /var/lib/apt/lists/*;

FROM ghcr.io/edgelesssys/edgelessrt-dev AS dev
LABEL description="EGo is an SDK to build confidential enclaves in Go - as simple as conventional Go programming!"
COPY --from=build /opt/ego /opt/ego
ENV PATH=${PATH}:/opt/ego/bin
ENTRYPOINT ["bash"]

FROM ghcr.io/edgelesssys/edgelessrt-deploy AS deploy
LABEL description="A runtime version of EGo to handle enclave-related tasks such as signing and running Go SGX enclaves."
COPY --from=build /opt/ego/bin/ /opt/ego/bin
COPY --from=build /opt/ego/share /opt/ego/share
ENV PATH=${PATH}:/opt/ego/bin
ENTRYPOINT ["bash"]
