from ubuntu:trusty

run apt-get update
run apt-get install --no-install-recommends -y libgettextpo-dev libgpgme11-dev libgpg-error-dev && rm -rf /var/lib/apt/lists/*;
run apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
run curl https://sh.rustup.rs -sSf | sh -s -- -y
run apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

