# This is a sample file that shows how one can easily build docker images
# inheriting one of the core images. It will copy in the bundle and the run.sh
# but otherwise not install packages etc. again.
#
# Build with 'docker build . -t awsdeepracercommunity/deepracer-robomaker:local -f docker/Dockerfile.localext --build-arg FROM_TAG=cpu-avx'
#