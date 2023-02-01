FROM unifyai/ivy-memory:latest

# Entrypoint
RUN echo '#!/bin/bash\n/usr/bin/xvfb-run --auto-servernum "$@"' > /entrypoint && \
    chmod a+x /entrypoint
ENTRYPOINT ["/entrypoint"]