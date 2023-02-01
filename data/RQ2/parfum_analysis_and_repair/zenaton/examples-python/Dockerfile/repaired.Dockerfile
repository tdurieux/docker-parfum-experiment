FROM python:3.5

WORKDIR /app

# Install Zenaton
RUN curl -f https://install.zenaton.com | sh

# Install dependencies
ADD requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["./start_zenaton"]