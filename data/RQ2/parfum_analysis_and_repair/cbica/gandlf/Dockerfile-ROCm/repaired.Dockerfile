# NOTE: ROCm is NOT supported by PyTorch LTS (1.8.2)
FROM rocm/pytorch:rocm4.5.2_ubuntu18.04_py3.8_pytorch_1.10.0
LABEL github="https://github.com/CBICA/GaNDLF"
LABEL docs="https://cbica.github.io/GaNDLF/"
LABEL version=1.0

# Quick start instructions on using Docker with ROCm: https://github.com/RadeonOpenCompute/ROCm-docker/blob/master/quick-start.md

# The base image contains ROCm, python 3.8 and pytorch already, no need to install those
RUN python3 -m pip install --upgrade pip
COPY . /GaNDLF
WORKDIR /GaNDLF
RUN python3 -m pip install --upgrade pip && python3 -m pip install openvino-dev==2022.1.0
RUN python3 -m pip install -e .
# Entrypoint forces all commands given via "docker run" to go through python, CMD forces the default entrypoint script argument to be gandlf_run
# If a user calls "docker run gandlf:[tag] gandlf_anonymize", it will resolve to running "python gandlf_anonymize" instead.
# CMD is inherently overridden by args to "docker run", entrypoint is constant.
ENTRYPOINT python3
CMD gandlf_run


# The below force the container commands to run as a nonroot user with UID > 10000.
# This greatly reduces UID collision probability between container and host, helping prevent privilege escalation attacks.
# As a side benefit this also decreases the likelihood that users on a cluster won't be able to access their files.
# See https://github.com/hexops/dockerfile as a best practices guide.