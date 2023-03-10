FROM python:3.7

RUN pip install --no-cache-dir --upgrade pip

RUN useradd -m worker
WORKDIR /project
# It is a real shame that WORKDIR doesn't honor the current user (or even take a chown option), so.....
RUN chown worker:worker /project
USER worker

RUN pip install --no-cache-dir --upgrade --user pipenv
ENV PATH=/home/worker/.local/bin:$PATH

COPY --chown=worker:worker . ./

# First we get the dependencies for the stack itself
RUN pipenv lock -r > requirements.txt
# Now add in any for the app, that the developer has added (there seems to be
# no easy way of specifying a different location for the Pipfile, so have to
# change the working directory!)
WORKDIR /project/userapp
RUN pipenv lock -r > ../requirements-additional.txt
# Now process the combined requirements
WORKDIR /project
RUN python -m pip install -r requirements.txt -t /project/deps
RUN python -m pip install -r requirements-additional.txt -t /project/deps

ENV PYTHONPATH=/project/deps
ENV FLASK_APP=server/__init__.py

ENV PORT=8080
EXPOSE 8080
CMD ["python", "-m", "flask", "run", "--host=0.0.0.0", "--port=8080"]