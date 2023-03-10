# This Dockerfile is designed for hacking on verless - the image
# distributed on Docker Hub is built using `application.Dockerfile`
# in the scripts directory.
#
# Build the image:
#   $ docker image build -t verless .
#
# For hacking on verless, mount the source code against /src:
#   $ docker container run -v $(pwd):/src verless
#
# This will run `go run cmd/verless/main.go`, meaning your code changes
# become visible immediately.
#
# Example: Change config.Version in to "my-version" and run the
# version command by appending it to the image name:
#
#   $ docker container run -v $(pwd):/src verless version
#     verless version my-version
#
# Also, the verless binary is available as `verless` command.
# Note that this is the version from the image build.