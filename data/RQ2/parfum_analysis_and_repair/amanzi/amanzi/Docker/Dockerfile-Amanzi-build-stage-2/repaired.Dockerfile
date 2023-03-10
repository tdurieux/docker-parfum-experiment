ARG amanzi_branch=master
FROM metsi/amanzi:${amanzi_branch}-temp-build-stage-1
LABEL Description="Amanzi: Build stage 2 and install in temporary Docker image."

# Arguments
ARG amanzi_branch=master
RUN echo "Amanzi branch = ${amanzi_branch}"
  
# Switch to amanzi_user
USER amanzi_user

# Change the Working Directory and update amanzi
WORKDIR /home/amanzi_user/amanzi

RUN ./bootstrap.sh --prefix=${AMANZI_PREFIX} \
   --amanzi-build-dir=/home/amanzi_user/amanzi_builddir/amanzi \
   --tpl-config-file=${AMANZI_TPLS_DIR}/share/cmake/amanzi-tpl-config.cmake \
   --parallel=4 --opt \
   --disable-structured \
   --disable-build_user_guide \
   --enable-alquimia --enable-pflotran --enable-crunchtope \
   --with-mpi=/usr \
   --enable-shared \
   --enable-build_stage_2