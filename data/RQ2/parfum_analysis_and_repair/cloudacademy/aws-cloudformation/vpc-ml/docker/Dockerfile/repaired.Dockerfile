FROM ubuntu:16.04
MAINTAINER CloudAcademy <jeremy.cook@cloudacademy.com>

RUN apt-get update -y
RUN apt-get install --no-install-recommends python-pip -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends unzip -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir virtualenv
RUN virtualenv /ml/frauddetectionenv
RUN /bin/bash -c "source /ml/frauddetectionenv/bin/activate"
RUN git clone https://github.com/cloudacademy/fraud-detection /ml/fraud-detection
RUN pip install --no-cache-dir -r /ml/fraud-detection/requirements-dev.txt
RUN curl -f -o /ml/fraud-detection/data/creditcard.csv.zip https://clouda-datasets.s3.amazonaws.com/creditcard.csv.zip
RUN unzip /ml/fraud-detection/data/creditcard.csv.zip -d /ml/fraud-detection/data
RUN ls -la /ml/fraud-detection/data
RUN df -h
RUN JOBLIB_TEMP_FOLDER=/tmp python /ml/fraud-detection/src/train.py
RUN export FLASK_APP=/ml/fraud-detection/src/flask_app.py
RUN printf "\n" >> /ml/fraud-detection/src/flask_app.py
RUN printf "@app.route(u\"/health\", methods=[u\"GET\"])\n" >> /ml/fraud-detection/src/flask_app.py
RUN printf "def health():\n" >> /ml/fraud-detection/src/flask_app.py
RUN printf "\treturn \"OK\", 200\n" >> /ml/fraud-detection/src/flask_app.py
RUN printf "\napp.run(host='0.0.0.0', debug=False)\n" >> /ml/fraud-detection/src/flask_app.py

EXPOSE 5000

WORKDIR /ml/fraud-detection/
ENV FLASK_APP /ml/fraud-detection/src/flask_app.py
CMD ["flask", "run"]
