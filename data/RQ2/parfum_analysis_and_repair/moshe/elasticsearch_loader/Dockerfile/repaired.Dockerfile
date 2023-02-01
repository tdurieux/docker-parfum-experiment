ARG python
from ${python}
RUN apk add --no-cache gcc musl-dev
COPY . /app
RUN cd /app && \
        pip install --no-cache-dir -e .[tests] && \
        cd inputs/redis/ && \
        pip install --no-cache-dir -e . && \
        cd ../s3/ && \
        pip install --no-cache-dir -e .
