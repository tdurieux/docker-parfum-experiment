FROM python:3.6

RUN apt-get update && apt-get install --no-install-recommends -y \
  vim \
  awscli \
  twine \
  jq && rm -rf /var/lib/apt/lists/*;

ENV PATH="${PATH}:/root/.local/bin/"

WORKDIR /aws-amicleaner
ADD . .
RUN python setup.py install
CMD bash
