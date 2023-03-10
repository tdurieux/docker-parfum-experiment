FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
COPY opa_linux_amd64_v0.25.2 opa
RUN chmod 755 ./opa

COPY petclinic.rego .
COPY run_opa.sh .

ENTRYPOINT ["./run_opa.sh"]