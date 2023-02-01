FROM owasp/zap2docker-stable

USER root
RUN apt-get update \
  && apt-get install --no-install-recommends -y \
  fonts-noto-cjk && rm -rf /var/lib/apt/lists/*;

USER zap
