FROM python:3.6
ARG KEARCH_COMMON_BRANCH="dev"

COPY packages/kearch_common /kearch/packages/kearch_common
RUN cd /kearch/packages/kearch_common && pip install --no-cache-dir -e .
RUN pip install --no-cache-dir pytest

COPY /packages/me-summary-updater /kearch/packages/me-summary-updater
WORKDIR /kearch/packages/me-summary-updater

CMD ["python", "-u", "main.py"]
