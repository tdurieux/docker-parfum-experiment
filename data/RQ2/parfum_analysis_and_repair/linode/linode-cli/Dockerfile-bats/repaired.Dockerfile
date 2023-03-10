FROM python:2

ENV TOKEN_1 ""
ENV TOKEN_2 ""
ENV TEST_ENVIRONMENT "prod"
ENV PYTHONPATH=.
ENV PATH="/usr/local/bin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.local/bin"

RUN apt-get update && apt-get install --no-install-recommends -y python3 python3-pip parallel \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src

# Install BATS testing framework
RUN git clone --branch v1.1.0 https://github.com/bats-core/bats-core.git \
    && cd bats-core \
    && ./install.sh /usr/local

WORKDIR /src/linode-cli

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt \
    && pip3 install --no-cache-dir -r requirements.txt

COPY . .

# Modify the cli.py to suppress version warnings by default
# Modify the cli.py to no longer verify certs and suppress warnings (allows running tests on custom environments)
RUN sed -i="" "s/data=body/data=body,verify=False/" /src/linode-cli/linodecli/cli.py \
    && sed -i="" "s/suppress_warnings = False/suppress_warnings = True/" /src/linode-cli/linodecli/cli.py \
    && echo "from requests.packages.urllib3.exceptions import InsecureRequestWarning\nrequests.packages.urllib3.disable_warnings(InsecureRequestWarning)" >> /src/linode-cli/linodecli/cli.py

# Override the base url in the openapi spec to the build argument
ARG API_OVERRIDE=api.linode.com
# Override the Spec url
ARG SPEC=https://www.linode.com/docs/api/openapi.yaml

# Fetch the openapi spec, build and install the Linode CLI
RUN curl -f -L --cacert ./cacert.pem -o ./openapi.yaml "${SPEC}" \
    && sed -n "s|url: https://api.linode.com/v4|url: https://${API_OVERRIDE}/v4|g;w cli-tests.yaml" /src/linode-cli/openapi.yaml \
    && git submodule init \
    && git submodule update \
    && make build SPEC=/src/linode-cli/cli-tests.yaml \
    && make install SPEC=/src/linode-cli/cli-tests.yaml \
    && cd dist \
    && pip install --no-cache-dir --user $(ls)

WORKDIR /src/linode-cli/test

ENTRYPOINT ["./test-runner.sh", "--force"]
