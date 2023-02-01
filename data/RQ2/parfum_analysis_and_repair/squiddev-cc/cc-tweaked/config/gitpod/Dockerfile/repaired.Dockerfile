FROM gitpod/workspace-base

USER gitpod

RUN sudo apt-get -q update \
 && sudo apt-get install --no-install-recommends -yq openjdk-8-jdk openjdk-16-jdk python3-pip npm \
 && sudo pip3 install --no-cache-dir pre-commit \
 && sudo update-java-alternatives --set java-1.8.0-openjdk-amd64 && rm -rf /var/lib/apt/lists/*;
