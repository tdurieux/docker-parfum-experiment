# Sign image in a separate stage to ensure that signing key is never part of the final image

FROM {{image}} as unsigned_image

RUN locale-gen en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

COPY gsc-signer-key.pem /gsc-signer-key.pem

RUN export PYTHONPATH="${PYTHONPATH}:$(find /graphene/meson_build_output/lib -type d -path '*/site-packages')" \
    && graphene-sgx-sign \
         --key /gsc-signer-key.pem \
         --manifest /entrypoint.manifest \
         --output /entrypoint.manifest.sgx

# This trick removes all temporary files from the previous commands (including gsc-signer-key.pem)