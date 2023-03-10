FROM onnc/onnc-community

# install packges
RUN sudo apt-get update \
    && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        expect \
        libpixman-1-0 \
        libglib2.0 \
        liblua5.2-0 \
        ssh \
    && sudo rm -rf /var/lib/apt/lists/*

RUN sudo -H pip install --no-cache-dir Pillow

# copy nvdla image directory
COPY --chown=onnc:onnc --from=nvdla/vp \
  /usr/local/nvdla /usr/local/nvdla

# copy dependent shared libraries
COPY --from=nvdla/vp \
  /usr/local/systemc-2.3.0 /usr/local/systemc-2.3.0

COPY --from=nvdla/vp \
  /usr/bin/aarch64_toplevel /usr/bin/

COPY --from=nvdla/vp \
  /usr/lib/libsimplecpu.so \
  /usr/lib/liblog.so \
  /usr/lib/libnvdla.so \
  /usr/lib/libcosim_sc_wrapper.so \
  /usr/lib/libnvdla_cmod.so \
  /usr/lib/libqbox-nvdla.so \
  /usr/lib/
