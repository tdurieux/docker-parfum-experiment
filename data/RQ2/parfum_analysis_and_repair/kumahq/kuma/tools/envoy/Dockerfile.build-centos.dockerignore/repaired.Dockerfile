# Overrides standard .dockerignore file from the project's root directory.
# It's important to have it empty because we're running 'docker build' with envoy's
# source directory as a workspace and by default it's $TMPDIR/envoy-sources.