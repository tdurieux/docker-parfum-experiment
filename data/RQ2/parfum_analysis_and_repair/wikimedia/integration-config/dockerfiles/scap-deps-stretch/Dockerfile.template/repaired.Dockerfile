FROM docker-registry.wikimedia.org/stretch:latest

{% set dev_deps|replace('\n', ' ') -%}
build-essential
lintian
debhelper
dh-python
python-all
python-setuptools
python-concurrent.futures
python-jinja2
python-pygments
python-yaml
python-requests
git
bash-completion
python-six
python-configparser
python-psutil
tox
flake8
{%- endset -%}

RUN {{ dev_deps | apt_install }}