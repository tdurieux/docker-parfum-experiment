FROM oddsocks/nanovdb:dev-base

ARG COMPILER
ARG CUDA_VER
ENV ROOT_PATH /repo

WORKDIR $ROOT_PATH/

COPY __dist/repo.tar $ROOT_PATH/

RUN \
    tar -xvf $ROOT_PATH/repo.tar && \
	dos2unix $ROOT_PATH/ci/*.sh && \
	chmod +x $ROOT_PATH/ci/*.sh && rm $ROOT_PATH/repo.tar

RUN \
    dos2unix ./docker/scripts/*.sh && \
	chmod +x ./docker/scripts/*.sh && \
    ./docker/scripts/linux_install_gcc.sh $COMPILER

RUN \
    ./ci/build_core.sh default $COMPILER $CUDA_VER Release \
        -DNANOVDB_USE_OPTIX=OFF \
        -DNANOVDB_USE_CUDA=ON

# current status:
#
# NANOVDB_BUILD_UNITTESTS must be false because gtest fails to compile inside wine with:
#    0080:err:msvcrt:get_calling_convention Unknown calling convention V
#    0081:err:msvcrt:get_calling_convention Unknown calling convention @
#    ...
#
# examples fails to run due to missing WINE implementation of fma.

#RUN \
#    wine --version && \
#    wine wineboot && \
#    ./ci/build_core_toolchain.sh msvc16 $ROOT_PATH/ci/wine-toolchain.cmake Release \
#        -DNANOVDB_USE_OPENVDB=OFF \
#        -DNANOVDB_USE_TBB=OFF \
#        -DNANOVDB_USE_ZLIB=OFF \
#        -DNANOVDB_USE_BLOSC=OFF \
#        -DNANOVDB_BUILD_TOOLS=ON \
#        -DNANOVDB_BUILD_UNITTESTS=OFF

#RUN \
#    ./ci/build_docs.sh

RUN \
    ./ci/test_core.sh default
#    ./ci/test_render.sh default
