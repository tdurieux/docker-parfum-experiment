FROM python:3.6
RUN apt update; apt install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
COPY src/tests/requirements.txt /app/requirements.txt
RUN pip3 install --no-cache-dir -r /app/requirements.txt
COPY src/ /app/
WORKDIR /app
CMD ["python", "-m", "pytest", "--log-cli-level=INFO", "tests/"]
