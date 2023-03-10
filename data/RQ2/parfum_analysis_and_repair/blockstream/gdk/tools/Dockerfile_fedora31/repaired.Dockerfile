FROM fedora:31@sha256:c97879f8bebe49744307ea5c77ffc76c7cc97f3ddec72fb9a394bd4e4519b388
COPY fedora31_deps.sh /deps.sh
COPY requirements.txt /requirements.txt
RUN /deps.sh && rm /deps.sh
CMD cd /sdk && ./tools/build.sh --clang