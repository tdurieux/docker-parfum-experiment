FROM ubuntu:18.04
RUN apt update
RUN apt install --no-install-recommends -y apt-utils build-essential && rm -rf /var/lib/apt/lists/*;

RUN apt install --no-install-recommends -y build-essential python python-pip python-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y python3 python3-pip python3-dev && rm -rf /var/lib/apt/lists/*;

COPY dev-requirements.txt dev-requirements.txt
ADD agent_build/requirement-files agent_build/requirement-files

RUN python2 -m pip install -r dev-requirements.txt

# so we create symlink to python3.5 with different name only to run tests.
# We need newer version of pip since old version don't support manylinux wheels
RUN python3 -m pip install --upgrade "pip==21.0"
RUN python3 -m pip --version
RUN python3 -m pip install -r dev-requirements.txt

RUN ln -sf /usr/bin/python3.6 /usr/bin/python_for_tests
