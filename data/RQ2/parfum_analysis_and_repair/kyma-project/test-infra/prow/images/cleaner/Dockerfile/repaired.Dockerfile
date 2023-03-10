FROM eu.gcr.io/kyma-project/prow/bootstrap:0.0.1

# Commit details

ARG commit
ENV IMAGE_COMMIT=$commit
LABEL io.kyma-project.test-infra.commit=$commit

WORKDIR /workspace
COPY cleaner.sh cleaner.sh
ENTRYPOINT ["./cleaner.sh"]

# Prow Tools
# hadolint ignore=DL3022
COPY --from=eu.gcr.io/kyma-project/test-infra/prow-tools:v20210401-294e46e5 /prow-tools /prow-tools
# for better access to prow-tools
ENV PATH=$PATH:/prow-tools