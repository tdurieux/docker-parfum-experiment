FROM 278380418400.dkr.ecr.eu-west-2.amazonaws.com/setup-tools:latest
FROM ubuntu:latest
RUN apt update && apt install --no-install-recommends -y curl jq python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir awscli --upgrade
COPY --from=0 /usr/src/setup-tools/compute_range_polynomial /usr/src/setup-tools/compute_range_polynomial
WORKDIR /usr/src/setup-post-process
COPY . .
CMD ./run