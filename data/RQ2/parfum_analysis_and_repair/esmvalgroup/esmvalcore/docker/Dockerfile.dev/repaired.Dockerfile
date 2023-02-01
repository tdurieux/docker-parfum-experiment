# To build this container, go to ESMValCore root folder and execute:
# This container is used to run the tests on CircleCI.
# docker build -t esmvalcore:development . -f docker/Dockerfile.dev
FROM condaforge/mambaforge

WORKDIR /src/ESMValCore
RUN apt update && DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y curl git ssh && apt clean && rm -rf /var/lib/apt/lists/*;
COPY environment.yml .
RUN mamba env create --name esmvaltool --file environment.yml && conda clean --all -y

# Make RUN commands use the new environment:
SHELL ["conda", "run", "--name", "esmvaltool", "/bin/bash", "-c"]

COPY . .
RUN pip install --no-cache-dir --no-cache .[test] && pip uninstall esmvalcore -y
