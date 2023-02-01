# Use qFlex as baseline
FROM qflex

# Copy relevant files
COPY ./tests/src/ /qflex/tests/src/

# Compile tests
WORKDIR /qflex/

# Arguments from docker-compose