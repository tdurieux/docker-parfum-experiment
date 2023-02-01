FROM circleci/node:8.12

RUN sudo apt update && sudo apt install --no-install-recommends createrepo dpkg-dev apt-utils gnupg2 gzip -y && sudo rm -rf /var/lib/apt/lists/*
