# Base OS
FROM debian

# Install requirements
RUN apt-get update
RUN apt-get install --no-install-recommends -y python3-dev python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cmake git && rm -rf /var/lib/apt/lists/*;

COPY ./ /qsim/
RUN pip3 install --no-cache-dir /qsim/

# Run test in a non-qsim directory
COPY ./qsimcirq_tests/ /test-install/

WORKDIR /test-install/

ENTRYPOINT python3 -m pytest ./
