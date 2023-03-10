FROM python:3.6
WORKDIR /usr/src/app
COPY gke/requirements.txt ./
COPY locustfile.py ./
COPY devicelist.csv ./
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 5557
EXPOSE 5558
EXPOSE 8089
CMD ["locust", "--master"]