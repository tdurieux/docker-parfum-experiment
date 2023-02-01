# Once an "Alpha" is properly tested and declared as *production ready*, a "pinned" version is created
# and published. Pinned versions are considered production ready, and the "latest" pinned version
# is pre-cached on the [bitrise.io](https://www.bitrise.io/) Linux/Android Virtual Machines.
# Read more about how versions are handled in the `README.md`.

FROM quay.io/bitriseio/bitrise-base:alpha-v2019_06_20-02_01-b1664

CMD bitrise --version
