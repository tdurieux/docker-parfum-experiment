# syntax=docker/dockerfile:experimental

# To around the lack of a overlayfs in presubmit jobs since they run on fargate
# we have to keep the layers to a minimum.
# All the source files and librarys are gatered into once folder on the base and then
# copied in the builder