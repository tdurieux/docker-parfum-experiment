FROM python:3.8-slim-buster

# Install auxiliary software
RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    vim && rm -rf /var/lib/apt/lists/*;

# Update pip and install requirements
RUN pip install --no-cache-dir -U pip
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy in the application files and install it locally
COPY ./docs /docs
WORKDIR /docs

EXPOSE 8000
CMD ["mkdocs", "serve", "--dev-addr=0.0.0.0:8000"]
