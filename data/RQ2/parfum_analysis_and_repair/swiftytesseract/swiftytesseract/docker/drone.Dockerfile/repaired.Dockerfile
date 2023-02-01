FROM ubuntu:20.04

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update -yq && \
    apt-get install --no-install-recommends -yq curl libtesseract-dev libleptonica-dev && \
    curl -f -s https://packagecloud.io/install/repositories/swift-arm/release/script.deb.sh | bash && \
    apt-get install --no-install-recommends -yq swiftlang && rm -rf /var/lib/apt/lists/*;