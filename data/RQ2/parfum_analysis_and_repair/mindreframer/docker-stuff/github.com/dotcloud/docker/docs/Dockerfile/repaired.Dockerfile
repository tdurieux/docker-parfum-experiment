from ubuntu:12.04
maintainer Nick Stinemates

run apt-get update && apt-get install --no-install-recommends -y python-setuptools make && rm -rf /var/lib/apt/lists/*;
run easy_install pip
add . /docs
run pip install --no-cache-dir -r /docs/requirements.txt
run cd /docs; make docs

expose 8000

workdir /docs/_build/html

entrypoint ["python", "-m", "SimpleHTTPServer"]
