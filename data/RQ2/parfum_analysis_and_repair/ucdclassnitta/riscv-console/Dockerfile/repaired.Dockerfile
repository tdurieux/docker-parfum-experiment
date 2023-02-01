FROM cjnitta/riscv_base

RUN apt-get update && apt-get install --no-install-recommends sudo libgtk-3-dev dbus-x11 -y && rm -rf /var/lib/apt/lists/*;

# Add user so that container does not run as root
RUN useradd -m docker

COPY . /code
WORKDIR /code


CMD ["/bin/bash"]
