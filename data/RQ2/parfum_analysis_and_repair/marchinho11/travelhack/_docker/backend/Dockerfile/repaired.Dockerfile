FROM python:3.8-slim-buster AS requirements_builder
ADD pyproject.toml /
ADD poetry.lock /
RUN pip install --no-cache-dir poetry
RUN poetry export -f requirements.txt --output requirements.txt

FROM python:3.8-slim-buster
RUN apt-get update && apt-get install --no-install-recommends -y build-essential gcc libc6-dev wget && rm -rf /var/lib/apt/lists/*;
ADD /backend /backend
COPY --from=requirements_builder /requirements.txt /backend/
WORKDIR /backend
RUN pip install --no-cache-dir -r requirements.txt
