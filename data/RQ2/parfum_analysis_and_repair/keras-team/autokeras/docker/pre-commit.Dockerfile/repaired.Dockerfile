FROM python:3.7

RUN pip install --no-cache-dir flake8 black isort

WORKDIR /autokeras
CMD ["python", "docker/pre_commit.py"]
