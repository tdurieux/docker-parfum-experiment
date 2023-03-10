FROM python:3.4

RUN apt-get update -y
RUN apt-get install --no-install-recommends -y unzip wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y default-jdk && rm -rf /var/lib/apt/lists/*;

RUN wget https://h2o-release.s3.amazonaws.com/h2o/rel-wolpert/8/h2o-3.18.0.8.zip
RUN unzip ./h2o-3.18.0.8.zip
RUN mv h2o-3.18.0.8/h2o.jar /tmp/

ADD ./requirements.txt /
RUN pip3 install --no-cache-dir -r /requirements.txt

ADD . /simple_tensorflow_serving/
WORKDIR /simple_tensorflow_serving/
RUN cp ./third_party/openscoring/openscoring-server-executable-1.4-SNAPSHOT.jar /tmp/

# RUN pip3 install simple-tensorflow-serving
RUN python ./setup.py install

EXPOSE 8500

# CMD ["simple_tensorflow_serving", "--port=8500", "--model_base_path=./models/tensorflow_template_application_model"]
CMD ["simple_tensorflow_serving", "--port=8500", "--model_config_file=./examples/model_config_file.json"]
