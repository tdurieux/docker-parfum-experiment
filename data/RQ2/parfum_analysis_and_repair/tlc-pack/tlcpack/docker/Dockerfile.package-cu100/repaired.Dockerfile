# Docker image: tlcpack/package-cu100

FROM pytorch/manylinux-cuda100

# install core
COPY install/centos_install_core.sh /install/centos_install_core.sh
RUN bash /install/centos_install_core.sh

# install cmake
COPY install/centos_install_cmake.sh /install/centos_install_cmake.sh
RUN bash /install/centos_install_cmake.sh

# build llvm
COPY install/centos_build_llvm.sh /install/centos_build_llvm.sh
RUN bash /install/centos_build_llvm.sh 10.0

# upgrade patchelf due to the bug in patchelf 0.10
# see details at https://stackoverflow.com/questions/61007071/auditwheel-repair-not-working-as-expected
COPY install/centos_install_patchelf.sh /install/centos_install_patchelf.sh
RUN bash /install/centos_install_patchelf.sh

# Install Arm Ethos-N NPU driver stack
COPY install/centos_install_arm_ethosn_driver_stack.sh /install/centos_install_arm_ethosn_driver_stack.sh
RUN bash /install/centos_install_arm_ethosn_driver_stack.sh

# Install Compute Library for Arm(r) Architecture (ACL)
COPY install/centos_install_arm_compute_library.sh /install/centos_install_arm_compute_library.sh
RUN bash /install/centos_install_arm_compute_library.sh

# Install Conda
COPY install/centos_install_conda.sh /install/centos_install_conda.sh
RUN bash /install/centos_install_conda.sh
ENV PATH=/opt/conda/bin:${PATH}

# install python packages
COPY install/centos_install_python_package.sh /install/centos_install_python_package.sh
RUN bash /install/centos_install_python_package.sh 3.7
RUN bash /install/centos_install_python_package.sh 3.8

COPY install/centos_install_auditwheel.sh /install/centos_install_auditwheel.sh
RUN bash /install/centos_install_auditwheel.sh

# Environment variables