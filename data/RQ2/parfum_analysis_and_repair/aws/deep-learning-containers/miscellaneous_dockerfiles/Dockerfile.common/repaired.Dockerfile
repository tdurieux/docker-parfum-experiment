# Use the Deep Learning Container as a base Image
ARG PRE_PUSH_IMAGE=""

FROM $PRE_PUSH_IMAGE

# Copy safety report generated from PRE_PUSH_IMAGE to docker image