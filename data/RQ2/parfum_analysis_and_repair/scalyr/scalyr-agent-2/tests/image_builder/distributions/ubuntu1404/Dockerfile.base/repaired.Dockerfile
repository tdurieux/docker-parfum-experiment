FROM ubuntu:14.04

RUN apt-get update -y

RUN apt-get install --no-install-recommends -y apt-utils build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python python-pip python-dev && rm -rf /var/lib/apt/lists/*;

COPY dev-requirements.txt dev-requirements.txt
ADD agent_build/requirement-files agent_build/requirement-files

# Upgrade pip so it supports Python version markers we use in our requirements file
RUN python2 -m pip install --upgrade --force-reinstall "pip==9.0.3"
RUN python2 -m pip install -r dev-requirements.txt

# we create symlink to python3.5 with different name only to run tests.
RUN apt-get install --no-install-recommends -y python3.5 python3-pip python3.5-dev && rm -rf /var/lib/apt/lists/*;

RUN ln -sf /usr/bin/python3.5 /usr/bin/python_for_tests
RUN python_for_tests -m pip install --upgrade --force-reinstall "pip==9.0.3"
RUN python_for_tests -m pip install -r dev-requirements.txt
RUN ln -s -f /usr/bin/python3.5 /usr/bin/python3
