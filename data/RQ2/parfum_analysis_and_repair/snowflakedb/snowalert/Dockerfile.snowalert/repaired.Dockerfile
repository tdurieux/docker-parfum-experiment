FROM python:3.7-slim-stretch

WORKDIR /var/task

RUN apt-get update && apt-get install --no-install-recommends -y r-base && rm -rf /var/lib/apt/lists/*;
RUN R -e "install.packages(c('dplyr', 'purrr', 'tidyr','MASS', 'tidyverse', 'broom','testthat'), repos = 'https://cloud.r-project.org')"

RUN pip install --no-cache-dir --upgrade pip virtualenv pyflakes

RUN mkdir -p ./snowalert
RUN virtualenv ./snowalert/venv
ENV PATH="/var/task/snowalert/venv/bin:${PATH}"

COPY ./src ./snowalert/src
COPY ./run ./run
COPY ./install ./install
RUN PYTHONPATH='' pip --no-cache-dir install ./snowalert/src/
RUN PYTHONPATH='' pip --no-cache-dir install alooma-pysdk requests

CMD ./run all
