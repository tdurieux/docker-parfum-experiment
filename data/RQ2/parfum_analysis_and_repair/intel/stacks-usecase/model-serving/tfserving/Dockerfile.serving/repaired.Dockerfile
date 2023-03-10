FROM sysstacks/dlrs-serving-ubuntu:v0.9.0

COPY scripts/serving_entrypoint.sh /usr/bin/serving_entrypoint.sh
COPY config/ /workspace

RUN chmod +x /usr/bin/serving_entrypoint.sh

# Expose port for REST API
EXPOSE 8501

# Set default values for model path
ENV MODEL_DIR=/models
RUN mkdir ${MODEL_DIR}

ENTRYPOINT ["/usr/bin/serving_entrypoint.sh"]