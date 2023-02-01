FROM python:3.7

# Copy in required files
COPY . ./

RUN apt-get update && apt-get install --no-install-recommends -y vim libpq-dev gcc && rm -rf /var/lib/apt/lists/*;

# Install Python Requirements
RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir -r requirements.txt

CMD echo "hello"
