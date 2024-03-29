FROM python:3.10-buster

LABEL Name=Schemathesis

WORKDIR /app

RUN groupadd --gid 1000 --system schemathesis && \
    useradd --uid 1000 --system schemathesis -g schemathesis -s /sbin/nologin

COPY --chown=1000:1000 pyproject.toml README.rst src ./

RUN apt-get update \
    && apt-get install --no-install-recommends -y build-essential libffi-dev libssl-dev curl \
    && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && pip install --no-cache-dir --upgrade pip && PATH=$HOME/.cargo/bin:$PATH pip install --no-cache-dir ./ \
    && apt remove -y build-essential libffi-dev libssl-dev curl \
    && PATH=$HOME/.cargo/bin:$PATH rustup self uninstall -y \
    && apt -y autoremove \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Needed for the `.hypothesis` directory
RUN chown -R 1000:1000 /app

USER schemathesis
ENTRYPOINT ["schemathesis"]
