# Note: development using the local Dockerfile is still work-in-progress
# Getting started: http://jorisroovers.github.io/gitlint/contributing/
ARG python_version_dotted

FROM python:${python_version_dotted}-stretch

RUN apt-get update && apt-get install --no-install-recommends -y git silversearcher-ag jq curl && rm -rf /var/lib/apt/lists/*; # software-properties-common contains 'add-apt-repository'


ADD . /gitlint
WORKDIR /gitlint

RUN pip install --no-cache-dir --ignore-requires-python -r requirements.txt
RUN pip install --no-cache-dir --ignore-requires-python -r test-requirements.txt

CMD ["/bin/bash"]
