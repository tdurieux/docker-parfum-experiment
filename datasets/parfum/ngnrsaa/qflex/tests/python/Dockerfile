# Use qFlex as baseline
FROM qflex

# Copy relevant files
COPY ./tests/python/ /qflex/tests/python/

# Compile tests
WORKDIR /qflex/

# Arguments from docker-compose
ARG OMP_NUM_THREADS

ENTRYPOINT make -j${OMP_NUM_THREADS:-8} run-py-tests
