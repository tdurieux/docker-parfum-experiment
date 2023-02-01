# ==================================================================
# module list
# ------------------------------------------------------------------
# flashlight       master     (git, CPU backend)
# ==================================================================

FROM flml/flashlight:cpu-base-consolidation-latest

# just in case for visibility
ENV MKLROOT="/opt/intel/mkl"

# ==================================================================
# flashlight with CPU backend
# ------------------------------------------------------------------
# Setup and build flashlight