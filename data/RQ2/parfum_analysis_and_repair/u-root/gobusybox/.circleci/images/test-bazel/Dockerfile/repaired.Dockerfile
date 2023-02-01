FROM cimg/base:2022.03

RUN sudo apt install -y --no-install-recommends apt-transport-https curl gnupg; rm -rf /var/lib/apt/lists/*; \
    curl -fsSL https://bazel.build/bazel-release.pub.gpg | \
          gpg --batch --dearmor > bazel.gpg; \
    sudo mv bazel.gpg /etc/apt/trusted.gpg.d/; \
    echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list;

RUN sudo apt-get update &&                                    \
    sudo apt-get install -y --no-install-recommends bazel; rm -rf /var/lib/apt/lists/*;
