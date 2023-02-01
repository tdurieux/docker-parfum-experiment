FROM tensorflow/tensorflow:2.4.1-gpu

RUN apt-get update && apt-get install --no-install-recommends -y python3-venv vim libgl1-mesa-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir poetry
COPY pyproject.toml ./
COPY poetry.lock ./
RUN poetry config virtualenvs.create false
RUN poetry install --no-root --no-dev
