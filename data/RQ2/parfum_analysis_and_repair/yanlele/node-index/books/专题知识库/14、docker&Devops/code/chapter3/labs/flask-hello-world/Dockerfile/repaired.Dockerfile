FROM python:2.7
LABEL maintainer="Peng Xiao<xiaoquwl@gmail.com>"
RUN pip install --no-cache-dir flask
COPY app.py /app/
WORKDIR /app
EXPOSE 5000
CMD ["python", "app.py"]
