# This docker file require binary files located at directory 'build/bin/',
# and the binary files must be built for Linux x64 platform.
# But the standard 'make build' command generates binary files at 'bin/',
# and may not target for Linux x64.
#
# To build docker images from this file, please build with command:
#    make build_docker