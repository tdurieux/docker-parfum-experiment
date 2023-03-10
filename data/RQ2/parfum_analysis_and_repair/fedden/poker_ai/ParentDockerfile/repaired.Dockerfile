FROM python:3.7
RUN mkdir /poker_ai
# Work from the root of the repo.
WORKDIR /poker_ai
# Supply '--build_arg LUT_DIR=research/blueprint_algo' here.
ARG LUT_DIR
# Copy pickle LUTs over.
COPY "${LUT_DIR}/flop_lossy_2.pkl" .
COPY "${LUT_DIR}/preflop_lossless.pkl" .
COPY "${LUT_DIR}/river_lossy_2.pkl" .
COPY "${LUT_DIR}/turn_lossy_2.pkl" .
# Set the environment variable for the tests
ENV LUT_DIR="/poker_ai" 
CMD ["/bin/bash"]