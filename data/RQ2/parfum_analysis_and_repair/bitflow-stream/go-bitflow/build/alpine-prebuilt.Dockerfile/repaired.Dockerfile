# bitflowstream/bitflow-pipeline:latest
# Copies pre-built binaries into the container. The binaries are built on the local machine beforehand:
# ./native-build.sh
# docker build -t bitflowstream/bitflow-pipeline:latest -f alpine-prebuilt.Dockerfile _output