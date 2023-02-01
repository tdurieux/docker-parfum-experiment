FROM rasa/rasa_core_sdk:0.13.1

RUN apt update -qq && apt -q --no-install-recommends -y -o Dpkg::Use-Pty=0 install -y git curl && rm -rf /var/lib/apt/lists/*;

ADD actions.requirements.txt /tmp/

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --quiet --progress-bar off --no-cache-dir -r /tmp/actions.requirements.txt


COPY . /app/actions
HEALTHCHECK --interval=300s --timeout=60s --retries=5 \
CMD curl -f http://0.0.0.0:5055/health || exit 1
