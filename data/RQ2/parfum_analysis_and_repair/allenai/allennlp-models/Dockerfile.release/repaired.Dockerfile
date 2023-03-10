# This Dockerfile is used to build an image from a specific PyPI release of allennlp and
# allennlp-models.
# It requires two build args: RELEASE and CUDA.
# RELEASE should be a allennlp/allennlp-models version, such as '1.2.2',
# CUDA should be a supported CUDA version, such '10.2'.

ARG RELEASE
ARG CUDA

FROM allennlp/allennlp:v${RELEASE}-cuda${CUDA}

# Need to specify this ARG again because the FROM stage consumes all args before it.