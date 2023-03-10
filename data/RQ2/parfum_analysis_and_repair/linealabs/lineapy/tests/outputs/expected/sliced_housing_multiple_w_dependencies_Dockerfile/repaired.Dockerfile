FROM apache/airflow:latest

RUN mkdir /tmp/installers
WORKDIR /tmp/installers

# copy all the requirements to run the current dag
COPY ./sliced_housing_multiple_w_dependencies_requirements.txt ./
# install the required libs
RUN pip install --no-cache-dir -r ./sliced_housing_multiple_w_dependencies_requirements.txt

WORKDIR /opt/airflow/dags
COPY . .

WORKDIR /opt/airflow

CMD [ "standalone" ]