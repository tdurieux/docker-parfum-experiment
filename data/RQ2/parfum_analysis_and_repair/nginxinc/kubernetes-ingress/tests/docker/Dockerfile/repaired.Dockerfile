# this is here so we can grab the latest version of kind and have dependabot keep it up to date
FROM kindest/node:v1.24.2

FROM python:3.10

RUN apt-get update \
	&& apt-get install --no-install-recommends -y curl git \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/tests

COPY --link tests/requirements.txt /workspace/tests/
RUN pip install --no-cache-dir -r requirements.txt

COPY --link deployments /workspace/deployments

RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
	&& install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
	&& apt-get update && apt-get install --no-install-recommends -y apache2-utils && rm -rf /var/lib/apt/lists/*;

COPY --link tests /workspace/tests

ENTRYPOINT ["python3", "-m", "pytest"]
