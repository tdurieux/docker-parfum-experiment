# This is a sample file that shows how one can easily build docker images
# inheriting one of the core images. This will upgrade the tensorflow for the gpu or gpu-gl image with one being compatible with RTX30.
#
# Build with 'docker build . -t awsdeepracercommunity/deepracer-robomaker:gpu-nv -f docker/Dockerfile.rtx30-tf --build-arg FROM_TAG=gpu'
#