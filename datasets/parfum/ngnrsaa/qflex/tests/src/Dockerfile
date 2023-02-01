# Use qFlex as baseline
FROM qflex

# Copy relevant files
COPY ./tests/src/ /qflex/tests/src/

# Compile tests
WORKDIR /qflex/

# Arguments from docker-compose
ARG OMP_NUM_THREADS

ENTRYPOINT make -j${OMP_NUM_THREADS:-8} run-cxx-tests
