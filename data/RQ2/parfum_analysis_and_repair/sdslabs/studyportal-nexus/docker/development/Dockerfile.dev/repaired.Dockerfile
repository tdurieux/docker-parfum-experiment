FROM python:3.7-stretch

RUN apt-get update \
    && apt-get install -y --no-install-recommends libexempi3 \
    && mkdir -p /var/log/studyportal.log && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/app

# Install Python dependency management tools
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir --upgrade setuptools \
    && pip install --no-cache-dir --upgrade pipenv

# Copy the requirements.txt into the container
COPY requirements.txt .

# Add the entrypoint script into the container and make it executable
ADD run.sh .
RUN chmod +x run.sh

# Install the dependencies system-wide
# TODO: Use build args to avoid installing dev dependencies in production
RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["./run.sh"]
