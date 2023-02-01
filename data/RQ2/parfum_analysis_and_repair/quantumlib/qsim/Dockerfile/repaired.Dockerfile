# Base OS
FROM debian

# Install baseline
RUN apt-get update && apt-get install --no-install-recommends -y g++ make wget && rm -rf /var/lib/apt/lists/*;

# Copy relevant files for simulation
COPY ./Makefile /qsim/Makefile
COPY ./apps/ /qsim/apps/
COPY ./circuits/ /qsim/circuits/
COPY ./lib/ /qsim/lib/

WORKDIR /qsim/

# Compile qsim
RUN make qsim

ENTRYPOINT ["/qsim/apps/qsim_base.x"]
