FROM gitpod/workspace-full:latest

USER gitpod

RUN pip3 install --no-cache-dir pytest==4.4.2 pytest-testdox mock
RUN npm i @learnpack/learnpack -g && learnpack plugins:install learnpack-python@0.0.36 && npm cache clean --force;

