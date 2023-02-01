FROM tensorflow/serving

# Install python3
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y python3.8 python3-pip curl && rm -rf /var/lib/apt/lists/*;

# Install required packages
RUN pip3 install --no-cache-dir requests && \
    pip3 install --no-cache-dir setuptools-rust && \
    pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir ntcore

# Copy scripts into image
COPY docker-entrypoint.sh /usr/local/bin/
COPY main.py /usr/local/bin/

# Set docker entrypoint
ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]

# Health check service
HEALTHCHECK --interval=5s --timeout=5m \
    CMD curl -f http://localhost:8501/v1/models/$DSP_WORKSPACE_ID || exit 1

# Execute the base tensorflow serving entrypoint
CMD ["sh", "/usr/bin/tf_serving_entrypoint.sh"]