from ubuntu:precise

run apt-get update
run apt-get -y --no-install-recommends install cvs && rm -rf /var/lib/apt/lists/*;
run apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
run apt-get -y --no-install-recommends install git-cvs && rm -rf /var/lib/apt/lists/*;
