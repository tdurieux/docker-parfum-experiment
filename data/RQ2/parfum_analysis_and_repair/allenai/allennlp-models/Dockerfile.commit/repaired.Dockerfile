# This Dockerfile is used to build an image from specific commits of allennlp and
# allennlp-models. It requires three build args: ALLENNLP_COMMIT, ALLENNLP_MODELS_COMMIT,
# and CUDA.
# ALLENNLP_COMMIT and ALLENNLP_MODELS_COMMIT should be set to the desired commit SHAs for each repo.
# CUDA should be set to a supported CUDA version such as '10.2' or '11.0'.

ARG ALLENNLP_COMMIT
ARG CUDA

FROM allennlp/commit:${ALLENNLP_COMMIT}-cuda${CUDA}

ARG ALLENNLP_MODELS_COMMIT

# Ensure allennlp isn't re-installed when we install allennlp-models.
ENV ALLENNLP_VERSION_OVERRIDE allennlp

# To be compatible with older versions of allennlp-models.