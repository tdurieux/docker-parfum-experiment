FROM centos:6

# Needed for python-pip package
RUN yum update -y
RUN yum install -y epel-release && rm -rf /var/cache/yum

# Needed for python35 package (epel-release only contains 3.4 which we don't support)
RUN curl -f 'https://setup.ius.io/' -o setup-ius.sh
RUN sh setup-ius.sh

RUN yum update -y
RUN yum install -y initscripts gcc && rm -rf /var/cache/yum
RUN yum install -y python2 python2-devel python-pip && rm -rf /var/cache/yum
RUN yum install -y python35u python35u-devel python35u-pip && rm -rf /var/cache/yum

# we create symlink to python3.5 with different name only to run tests.
RUN ln -sf /usr/bin/python3.5 /usr/bin/python_for_tests

RUN ln -sf /usr/bin/python3.5 /usr/bin/python3

#RUN python_for_tests -m pip install -r dev-requirements.txt

COPY py26-unit-tests-requirements.txt py26-unit-tests-requirements.txt
COPY dev-requirements.txt dev-requirements.txt
ADD agent_build/requirement-files agent_build/requirement-files

RUN pip install --no-cache-dir -r py26-unit-tests-requirements.txt

# We need newer version of pip since old version don't support manylinux wheels
RUN python3 -m pip install --upgrade "pip==21.0"
RUN python3 -m pip --version
RUN python3 -m pip install -r dev-requirements.txt
