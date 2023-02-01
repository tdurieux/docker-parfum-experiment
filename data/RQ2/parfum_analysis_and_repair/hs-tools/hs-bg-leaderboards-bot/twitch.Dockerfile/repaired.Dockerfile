FROM python:3.8
RUN pip3 install --no-cache-dir pipenv
ENV PROJECT_DIR .
WORKDIR ${PROJECT_DIR}

COPY . ${PROJECT_DIR}/

RUN pip3 install --no-cache-dir -r requirements.txt

WORKDIR ${PROJECT_DIR}/src

RUN pipenv install
CMD ["pipenv", "run", "python", "twitch.py"]
