FROM datawire/forge-base:5

WORKDIR /work

COPY requirements.txt dev-requirements.txt ./
RUN pip install --no-cache-dir -r dev-requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Bleh, this is really only necessary to make versioneer work
COPY .git .git
COPY bridge bridge
COPY .gitattributes .gitignore .travis.yml DEVELOPING.md Dockerfile Dockerfile.base README.md dev.sh devcurl.sh entrypoint.sh env.in ./

COPY scripts scripts
COPY forge forge
COPY examples examples
COPY docs docs
COPY Makefile setup.cfg setup.py versioneer.py MANIFEST.in LICENSE ./
COPY entrypoint.sh /

RUN pip install --no-cache-dir -e .

ENTRYPOINT ["/entrypoint.sh"]
