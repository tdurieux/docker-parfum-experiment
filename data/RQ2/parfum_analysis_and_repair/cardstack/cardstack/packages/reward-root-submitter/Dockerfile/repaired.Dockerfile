# build stage
FROM python:3.9 AS builder

# install PDM
RUN pip install --no-cache-dir -U pip setuptools wheel
RUN pip install --no-cache-dir pdm

# copy files
COPY pyproject.toml pdm.lock /project/

# install dependencies
WORKDIR /project
RUN pdm install --prod --no-lock --no-editable


# run stage
FROM python:3.9-slim

# retrieve packages from build stage
ENV PYTHONPATH=/project/pkgs
COPY --from=builder /project/__pypackages__/3.9/lib /project/pkgs
COPY . /project
WORKDIR /project
# set command/entrypoint, adapt to fit your needs
CMD ["python", "-m", "reward_root_submitter.main"]