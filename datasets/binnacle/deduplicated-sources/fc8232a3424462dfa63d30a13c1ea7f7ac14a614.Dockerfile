# Once an "Alpha" is properly tested and declared as *production ready*, a "pinned" version is created
# and published. Pinned versions are considered production ready, and the "latest" pinned version
# is pre-cached on the [bitrise.io](https://www.bitrise.io/) Linux/Android Virtual Machines.
# Read more about how versions are handled in the `README.md`.

FROM bitriseio/docker-android-alpha:v2017_09_07-10_07-b740

CMD bitrise --version
