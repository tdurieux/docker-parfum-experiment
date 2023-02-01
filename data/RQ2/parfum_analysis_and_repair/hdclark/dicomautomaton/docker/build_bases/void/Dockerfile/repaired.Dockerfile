# NOTE: This Dockerfile should be interepretted relative to the DICOMautomaton repo root.

FROM voidlinux/voidlinux-musl

LABEL maintainer="http://www.halclark.ca" \
      description="DICOMautomaton Void Linux build base."

WORKDIR /scratch_base
COPY docker/build_bases/void /scratch_base

# Ensure something in the image can interpret bash she-bangs.