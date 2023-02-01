# Copy the main source code
COPY --chown=<%= chown %> exe ${RUNNERS_DIR}/exe
COPY --chown=<%= chown %> lib ${RUNNERS_DIR}/lib

ENV PATH ${RUNNERS_DIR}/exe:${PATH}

# Run as non-root user