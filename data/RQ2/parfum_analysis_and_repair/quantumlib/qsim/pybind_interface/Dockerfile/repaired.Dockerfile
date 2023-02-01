# Base OS
FROM qsim

# Install additional requirements
RUN apt-get install --no-install-recommends -y python3-dev python3-pybind11 python3-pytest python3-pip && rm -rf /var/lib/apt/lists/*;

# The --force flag is used mainly so that the old numpy installation from pybind
# gets replaced with the one cirq requires
RUN pip3 install --no-cache-dir --prefer-binary cirq-core --force

# Copy relevant files
COPY ./pybind_interface/ /qsim/pybind_interface/
COPY ./qsimcirq/ /qsim/qsimcirq/
COPY ./qsimcirq_tests/ /qsim/qsimcirq_tests/

WORKDIR /qsim/

# Build pybind code early to cache the results
RUN make -C /qsim/ pybind

# Compile and run qsim tests
ENTRYPOINT make -C /qsim/ run-py-tests
