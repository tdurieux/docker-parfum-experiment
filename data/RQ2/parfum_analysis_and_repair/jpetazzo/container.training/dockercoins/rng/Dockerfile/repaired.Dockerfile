FROM python:alpine
RUN pip install --no-cache-dir Flask
COPY rng.py /
CMD ["python", "rng.py"]
EXPOSE 80
