
# https://hub.docker.com/_/python
FROM python:3.7-slim

# Copy local code to the container image.
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . .

# Install dependencies.
RUN pip install -r requirements.txt

# Run the web service on container startup.
CMD exec functions-framework --target=goblet_entrypoint
