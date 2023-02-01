# This container runs `resh`. If the `--wait` flag is provided it will instead
# go into an endless loop and wait for users to exec `resh` inside the container.
# The idea being that this container is e.g. deployed into a k8s environment
# having access to `resotocore`. Users can then authenticate with the k8s cluster
# and kubectl exec into the container to run `resh`.