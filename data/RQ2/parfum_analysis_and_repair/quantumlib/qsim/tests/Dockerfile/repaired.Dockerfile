# Base OS
FROM qsim

# Install additional requirements
RUN apt-get install --no-install-recommends -y cmake git && rm -rf /var/lib/apt/lists/*;

# Copy relevant files
COPY ./tests/ /qsim/tests/

WORKDIR /qsim/

# Compile and run qsim tests
ENTRYPOINT make -C /qsim/ run-cxx-tests