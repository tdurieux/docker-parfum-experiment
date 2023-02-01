from ubuntu:12.04
run apt-get update && apt-get install --no-install-recommends -y python python-dev python-setuptools && rm -rf /var/lib/apt/lists/*;
run easy_install pip
run pip install --no-cache-dir nltk
run pip install --no-cache-dir numpy
run python -m nltk.downloader all
cmd ["bash"]
