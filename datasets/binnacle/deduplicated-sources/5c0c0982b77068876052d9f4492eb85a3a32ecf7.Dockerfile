FROM istio-builder:latest

# Create bootstrap user
ENV HOME /home/bootstrap
RUN useradd -c "Bootstrap user" -d ${HOME} -G docker,sudo -m bootstrap -s /bin/bash
USER bootstrap
WORKDIR ${HOME}

# Explicitly set bazel cache, to avoid cache issues with checking out
# code and running bazel in different dir than the calling script.
ENV TEST_TMPDIR /home/bootstrap/.cache/bazel

# Add bootstrap, the test harness (checks out code, captures log and status)
# Add entrypoint that runs bootstrap with appropriate arguments
ADD docker/istio_builders/prow_builder/bootstrap/bootstrap.py /usr/local/bin/
RUN sudo chmod +rx /usr/local/bin/bootstrap.py

# Add entrypoint that runs bootstrap with appropriate arguments
ADD docker/istio_builders/prow_builder/entrypoint.sh /usr/local/bin/entrypoint
run sudo chmod +rx /usr/local/bin/entrypoint

# Add gitconfig
ADD docker/istio_builders/prow_builder/gitconfig ${HOME}/.gitconfig
run sudo chmod +r ${HOME}/.gitconfig

# Set CI variable which can be checked by test scripts to verify
# if running in the continuous integration environment.
ENV CI bootstrap

ENTRYPOINT ["entrypoint"]
