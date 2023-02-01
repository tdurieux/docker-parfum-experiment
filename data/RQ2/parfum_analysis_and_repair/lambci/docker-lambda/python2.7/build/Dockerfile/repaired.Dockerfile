FROM lambci/lambda:python2.7

FROM lambci/lambda-base:build

ENV AWS_EXECUTION_ENV=AWS_Lambda_python2.7

COPY --from=0 /var/runtime /var/runtime
COPY --from=0 /var/lang /var/lang
COPY --from=0 /var/rapid /var/rapid

# Add these as a separate layer as they get updated frequently
RUN curl -f --silent --show-error --retry 5 https://bootstrap.pypa.io/2.7/get-pip.py | python && \
  pip install -U 'virtualenv>=16.0.0,<20.0.0' pipenv wheel --no-cache-dir && \
  curl -f -sSL https://raw.githubusercontent.com/python-poetry/poetry/1.1.4/get-poetry.py | POETRY_VERSION=1.1.4 python && \
  pip install -U awscli boto3 aws-sam-cli==0.22.0 aws-lambda-builders==0.4.0 --no-cache-dir

ENV PATH=/root/.poetry/bin:$PATH
