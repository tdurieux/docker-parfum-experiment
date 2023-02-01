# Dockerfile for EvaluateSegmentation.
#
# Build image:
#   docker build --tag evaluatesegmentation .
#
# Run image:
#   docker run --rm -it -v $PWD:/data evaluatesegmentation /data/reference.nii.gz /data/segmentation.nii.gz