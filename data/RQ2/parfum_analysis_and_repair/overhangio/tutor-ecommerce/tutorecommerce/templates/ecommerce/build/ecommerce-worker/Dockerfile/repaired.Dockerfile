FROM docker.io/ubuntu:20.04

RUN apt update && \
  apt install --no-install-recommends -y git-core language-pack-en python3 python3-pip python3-venv && rm -rf /var/lib/apt/lists/*;

ARG APP_USER_ID=1000
RUN useradd --home-dir /openedx --create-home --shell /bin/bash --uid ${APP_USER_ID} app
USER ${APP_USER_ID}

RUN mkdir /openedx/ecommerce_worker && \
    git clone https://github.com/edx/ecommerce-worker.git --branch {{ OPENEDX_COMMON_VERSION }} --depth 1 /openedx/ecommerce_worker
WORKDIR /openedx/ecommerce_worker

# Install python venv
RUN python3 -m venv ../venv/
ENV PATH "/openedx/venv/bin:$PATH"
RUN pip install --no-cache-dir setuptools==62.1.0 pip==22.0.4 wheel==0.37.1
RUN pip install --no-cache-dir -r requirements/production.txt

ENV WORKER_CONFIGURATION_MODULE ecommerce_worker.settings.production
CMD celery worker --app=ecommerce_worker.celery_app:app --loglevel=info  --maxtasksperchild 100 --queue=fulfillment,email_marketing
