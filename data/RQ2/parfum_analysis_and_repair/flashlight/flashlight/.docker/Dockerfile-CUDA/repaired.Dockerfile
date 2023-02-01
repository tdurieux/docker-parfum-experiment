# ==================================================================
# module list
# ------------------------------------------------------------------
# flashlight       master     (git, CUDA backend)
# ==================================================================

FROM flml/flashlight:cuda-base-consolidation-latest

# just in case for visibility
ENV MKLROOT="/opt/intel/mkl"

# ==================================================================
# flashlight with CUDA backend
# ------------------------------------------------------------------
# Setup and build flashlight