ARG amanzi_tpls_ver=latest
FROM metsi/amanzi-tpls:${amanzi_tpls_ver}-mpich
LABEL Description="Amanzi: Build stage 1 and install in temporary Docker image."

# Switch to amanzi_user
USER amanzi_user

RUN echo "${AMANZI_PREFIX}"
RUN echo "${AMANZI_TPLS_DIR}"

# Arguments
ARG amanzi_branch=master
ARG amanzi_pr=false

# Change the Working Directory and update amanzi
WORKDIR /home/amanzi_user/amanzi

# Make sure we have updated branch information
RUN echo "Amanzi branch = $amanzi_branch"
RUN git pull
RUN git branch --list
# Checkout the branch and update it
RUN git checkout $amanzi_branch
RUN git pull
 
RUN ./bootstrap.sh --prefix=${AMANZI_PREFIX} \
   --amanzi-build-dir=/home/amanzi_user/amanzi_builddir/amanzi \
   --tpl-config-file=${AMANZI_TPLS_DIR}/share/cmake/amanzi-tpl-config.cmake \
   --parallel=4 --opt \
   --disable-structured \
   --disable-build_user_guide \
   --enable-alquimia --enable-pflotran --enable-crunchtope \
   --with-mpi=/usr \
   --enable-shared \
   --enable-build_stage_1