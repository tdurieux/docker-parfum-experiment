FROM python:latest AS gitlab-ci

# Install dependencies.
RUN pip install --no-cache-dir bandit pycodestyle pylint pytest semgrep
