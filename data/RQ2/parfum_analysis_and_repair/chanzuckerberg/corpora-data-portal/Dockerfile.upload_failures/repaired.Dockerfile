FROM public.ecr.aws/lambda/python:3.8

COPY backend/corpora/upload_failures/requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

COPY backend/corpora/upload_failures .
COPY backend/__init__.py ./backend/__init__.py
COPY backend/corpora/__init__.py ./backend/corpora/__init__.py
COPY backend/corpora/common ./backend/corpora/common
COPY backend/corpora/dataset_processing ./backend/corpora/dataset_processing
COPY backend/corpora/lambdas/upload_failures ./backend/corpora/upload_failures

ARG HAPPY_BRANCH="unknown"
ARG HAPPY_COMMIT=""
LABEL branch=${HAPPY_BRANCH}
LABEL commit=${HAPPY_COMMIT}
ENV COMMIT_SHA=${HAPPY_COMMIT}
ENV COMMIT_BRANCH=${HAPPY_BRANCH}

CMD ["app.handle_failure"]
