FROM ubuntu
ARG CHEEK_ARCH="linux/amd64"
WORKDIR /app
RUN apt update; apt install --no-install-recommends wget -y && rm -rf /var/lib/apt/lists/*;
RUN wget https://storage.googleapis.com/better-unified/${CHEEK_ARCH}/cheek
RUN chmod +x cheek
ENTRYPOINT [ "./cheek" ]
CMD ["run", "job_spec.yaml"]