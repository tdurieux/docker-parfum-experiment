# This is not included in integration tests because docker build does not exploit Dockerfile.dockerignore
# See https://github.com/moby/moby/issues/12886#issuecomment-523706042 for more details
# This dockerfile makes sure Dockerfile.dockerignore is working
# If so then ignore_relative/foo should copy to /foo
# If not, then this image won't build because it will attempt to copy three files to /foo, which is a file not a directory