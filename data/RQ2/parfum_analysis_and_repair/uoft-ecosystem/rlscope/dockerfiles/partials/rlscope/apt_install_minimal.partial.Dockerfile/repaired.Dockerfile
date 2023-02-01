USER root

# rlscope-banner requirements.
RUN apt-get update && apt-get install -y --no-install-recommends \
    figlet && rm -rf /var/lib/apt/lists/*;

USER ${RLSCOPE_USER}
