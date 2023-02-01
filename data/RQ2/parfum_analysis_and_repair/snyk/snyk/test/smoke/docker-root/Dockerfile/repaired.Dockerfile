FROM node:12

COPY ./smoke/ /snyk/smoke/
COPY ./fixtures/ /snyk/fixtures/

RUN apt-get update && apt-get install --no-install-recommends -y curl jq && rm -rf /var/lib/apt/lists/*;
RUN /snyk/smoke/install-shellspec.sh --yes
ENV PATH="/root/.local/bin:${PATH}"

WORKDIR /snyk/smoke/

ENTRYPOINT [ "./docker-root/entrypoint.sh" ]
