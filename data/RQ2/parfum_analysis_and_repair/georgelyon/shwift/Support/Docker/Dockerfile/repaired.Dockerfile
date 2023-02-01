FROM swift:5.6-focal
# FROM swiftlang/swift:nightly-main-focal

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
  xxd && rm -rf /var/lib/apt/lists/*;