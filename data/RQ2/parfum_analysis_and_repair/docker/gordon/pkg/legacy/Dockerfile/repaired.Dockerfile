from ubuntu:12.04
maintainer Nick Stinemates

run apt-get install --no-install-recommends -y python-setuptools && rm -rf /var/lib/apt/lists/*;
run easy_install pip

add . /website
run pip install --no-cache-dir -r /website/requirements.txt
env PYTHONPATH /website
expose 5000

cmd ["python", "website/web/server.py"]
