# Use qFlex as baseline
FROM qflex

# Copy relevant files
COPY ./tests/python/ /qflex/tests/python/

# Compile tests
WORKDIR /qflex/

# Arguments from docker-compose