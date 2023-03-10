FROM python

RUN python -m pip install --upgrade pip
RUN curl -f -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3
ENV PATH "/root/.poetry/bin:$PATH"

RUN mkdir /src
WORKDIR /src

COPY pyproject.toml poetry.lock ./

# # This is to fix the error: ModuleNotFoundError: No module named 'cleo'
# # Source: https://github.com/python-poetry/poetry/issues/553#issuecomment-1003452076
# RUN python -m pip install cleo tomlkit poetry.core requests cachecontrol cachy html5lib pkginfo virtualenv lockfile pexpect shellingham numpy
RUN poetry install

CMD poetry run mkdocs serve -f docs/mkdocs.yml --dev-addr=0.0.0.0:8000
