ARG PYTHON_VERSION
FROM python:${PYTHON_VERSION}-slim

WORKDIR /app

RUN apt-get --allow-releaseinfo-change update
RUN apt-get install --no-install-recommends gcc g++ libssl-dev libffi-dev rustc -y && rm -rf /var/lib/apt/lists/*;
RUN python -m pip install --upgrade pip
RUN pip install --no-cache-dir poetry

COPY pyproject.toml poetry.lock ./

RUN poetry install --no-dev --no-root

# PYTHONPATH set after install to prevent bugs
ENV PYTHONPATH="src"

COPY . .

ENTRYPOINT ["poetry", "run", "python", "src/main.py"]
