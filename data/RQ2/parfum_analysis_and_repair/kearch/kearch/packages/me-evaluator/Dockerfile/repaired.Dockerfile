FROM python:3.6
ARG KEARCH_COMMON_BRANCH="dev"

# Install kearch_common
COPY packages/kearch_evaluator /kearch/packages/kearch_evaluator
RUN cd /kearch/packages/kearch_evaluator && pip install --no-cache-dir -e .

# Install kearch_common
COPY packages/kearch_common /kearch/packages/kearch_common
RUN cd /kearch/packages/kearch_common && pip install --no-cache-dir -e .

COPY packages/me-evaluator /kearch/packages/me-evaluator
WORKDIR /kearch/packages/me-evaluator

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "-u", "flask_main.py"]
