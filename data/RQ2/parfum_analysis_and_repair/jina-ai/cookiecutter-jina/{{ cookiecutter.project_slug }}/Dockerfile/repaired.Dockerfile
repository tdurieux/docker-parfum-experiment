FROM jinaai/jina:{{ cookiecutter.jina_version }}

COPY . /workspace
WORKDIR /workspace

RUN apt-get update && pip install --no-cache-dir -r requirements.txt

RUN python app.py dryrun

ENTRYPOINT ["python", "app.py"]
