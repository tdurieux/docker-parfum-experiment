# The reason this isn't in ./scripts/export is because we want to easily just
# be able to copy our Taylor source code into the docker image and you can't
# copy from parent folders. This stops us having to clone the Taylor repository
# and allows us to build export images for development code.