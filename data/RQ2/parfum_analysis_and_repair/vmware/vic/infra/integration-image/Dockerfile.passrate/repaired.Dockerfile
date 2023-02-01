# Building:
# docker build --no-cache -t vic-pass-rate -f Dockerfile.passrate ../..
# docker tag vic-pass-rate gcr.io/eminent-nation-87317/vic-pass-rate:1.x
# gcloud auth login
# gcloud docker -- push gcr.io/eminent-nation-87317/vic-pass-rate:1.x
# download and install harbor certs, then docker login, then:
# docker tag vic-pass-rate wdc-harbor-ci.eng.vmware.com/default-project/vic-pass-rate:1.x
# docker push wdc-harbor-ci.eng.vmware.com/default-project/vic-pass-rate:1.x

FROM vmware/photon:2.0

RUN set -eux; \
     tdnf distro-sync --refresh -y; \
# Removing toybox installs GNU date