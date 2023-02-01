FROM python:3.8.3

RUN apt-get update
RUN ln -s /mnt/bes/pcm $HOME/ScenarioData

COPY powersimdata/utility/templates /mnt/bes/pcm/

WORKDIR /PowerSimData
COPY Pipfile .
COPY Pipfile.lock .
RUN pip install --no-cache-dir -U pip pipenv ipython; \
    pipenv sync --dev --system;

COPY . .
RUN pip install --no-cache-dir .

CMD ["ipython"]
