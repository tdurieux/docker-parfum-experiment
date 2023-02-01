# inspired by https://github.com/aferrero2707/appimage-testsuite
# installing libraries included in https://raw.githubusercontent.com/probonopd/AppImages/master/excludelist
FROM ubuntu:18.04
RUN apt-get update && apt-get install --no-install-recommends -y libasound2 libegl1-mesa libfontconfig1 libgl1-mesa-glx libgmp10 libharfbuzz0b libjack0 libp11-kit0 libx11-6 && rm -rf /var/lib/apt/lists/*;
