FROM friwidev/jcefdocker:linux-latest AS stage

LABEL jcefbuild=true

#Declare build type argument (Release or Debug)
ARG BUILD_TYPE

#Declare architecture argument (arm64, arm/v6, 386 or amd64)
ARG TARGETARCH

#Declare git args
ARG REPO
ARG REF

WORKDIR /builder
#Copy existing sources, if any
COPY jcef /jcef
#Copy prebuild classes, if any
COPY out/linux32 /prebuild
#Copy additional natives
COPY natives /natives

#Copy cmake patching script
COPY scripts/patch_cmake.py .
COPY patch/CMakeLists.txt.patch .

#Copy and launch run script
COPY scripts/run_linux.sh .
RUN chmod +x run_linux.sh
RUN ./run_linux.sh

#Export built files
FROM scratch AS export-stage
COPY --from=stage /jcef/binary_distrib.tar.gz .
COPY --from=stage /jcef/target target
COPY --from=stage /jcef/third_party third_party
COPY --from=stage /jcef/buildtools buildtools
COPY --from=stage /jcef/jcef_build jcef_build