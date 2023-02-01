FROM python:3.10-slim

# Copy
WORKDIR /app
COPY rsserpent rsserpent
COPY requirements.txt ./
COPY scripts/docker-entrypoint.sh /

# Dependencies
RUN pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir uvicorn && \
    pip cache purge

# Run
EXPOSE 8000
ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "uvicorn", "rsserpent:app", "--host", "0.0.0.0" ]
