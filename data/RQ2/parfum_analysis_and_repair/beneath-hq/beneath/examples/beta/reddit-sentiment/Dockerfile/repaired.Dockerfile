FROM python:3.7
WORKDIR /app
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY stream_submissions.py coronavirus-posts.graphql ./
CMD ["python", "stream_submissions.py"]
