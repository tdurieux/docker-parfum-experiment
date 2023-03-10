FROM gitpod/workspace-full:latest

USER gitpod

RUN pip3 install --no-cache-dir pytest==4.4.2 mock pytest-testdox toml
RUN npm i @learnpack/learnpack -g && learnpack plugins:install learnpack-python@0.0.35 && npm cache clean --force;
