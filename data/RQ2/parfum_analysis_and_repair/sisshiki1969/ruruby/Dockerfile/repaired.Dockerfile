FROM rust:1

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Configure apt and install packages
RUN apt-get update \
  && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
  #
  # Verify git, needed tools installed \
  && apt-get -y --no-install-recommends install git iproute2 procps lsb-release \
  #
  # Install other dependencies
  && apt-get install --no-install-recommends -y lldb \
  #
  # Install Rust components
  && rustup update \
  && rustup component add rls rust-analysis rust-src rustfmt clippy \
  && rustup toolchain install nightly \
  && rustup default nightly \
  #
  # Install Ruby
  && apt-get install --no-install-recommends -y rbenv \
  && echo 'eval "$(rbenv init -)"' >> ~/.bash_profile \
  && git clone https://github.com/sisshiki1969/ruruby.git && rm -rf /var/lib/apt/lists/*;

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=