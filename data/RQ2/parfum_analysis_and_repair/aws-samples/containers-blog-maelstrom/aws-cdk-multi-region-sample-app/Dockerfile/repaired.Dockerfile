FROM public.ecr.aws/amundsen-dependancies/python3.7-slim:latest
RUN pip install --no-cache-dir flask && pip install --no-cache-dir requests
WORKDIR /app
COPY app.py /app/app.py
ENTRYPOINT ["python"]
CMD ["/app/app.py"]