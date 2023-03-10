ARG VERSION

FROM pyodide/pyodide-env:${VERSION}

USER root

ENV EMSDK_NUM_CORES=4 EMCC_CORES=4 PYODIDE_JOBS=4

COPY . pyodide

# the rm at the end deletes the build results such that the resulting image can still be used for building pyodide
# from source (including partial and customized builds). Due to the previous run of make, builds
# executed with this image will be much faster than the ones executed with pyodide-env
RUN cd pyodide && PYODIDE_PACKAGES='*' make && rm -r ./dist