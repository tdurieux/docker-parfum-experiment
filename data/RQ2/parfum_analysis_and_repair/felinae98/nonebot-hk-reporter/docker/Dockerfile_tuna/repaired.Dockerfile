FROM python:3.9
RUN python3 -m pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN python3 -m pip install poetry && poetry config virtualenvs.create false
WORKDIR /app
COPY ./pyproject.toml ./poetry.lock* /app/
RUN poetry install --no-root --no-dev
ADD src /app/src
ADD bot.py /app/
ENV HOST=0.0.0.0
CMD ["python", "bot.py"]