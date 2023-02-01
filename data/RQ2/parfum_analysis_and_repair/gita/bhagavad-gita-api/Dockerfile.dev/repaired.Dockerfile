FROM python:3.9

ENV VENV_PATH="/venv"
ENV PATH="$VENV_PATH/bin:$PATH"

WORKDIR /app

RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends netcat -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade poetry
RUN python -m venv /venv

COPY . .

RUN poetry build && \
    /venv/bin/pip install --upgrade pip wheel setuptools && \
    /venv/bin/pip install dist/*.whl


ENTRYPOINT [ "./wait_for_db.sh" ]

CMD bhagavad-gita-api
