# Based on https://docs.travis-ci.com/user/common-build-problems/#Troubleshooting-Locally-in-a-Docker-Image
FROM travisci/ci-garnet:packer-1513287432-2ffda03

ENV TRAVIS_BUILD_DIR /root

ENV TARGET linux
ENV COMPILER gcc6

# Run install.sh installing