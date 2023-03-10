FROM python:3.6

ENV HOME /home/user
RUN useradd --create-home --home-dir $HOME user \
  && chown -R user:user $HOME

RUN pip install --no-cache-dir pipenv

USER user

COPY . /code
WORKDIR /code

RUN pipenv install --dev

VOLUME ["/code"]
VOLUME ["$HOME/.gnupg"]

CMD ["pipenv", "run", "python", "manage.py", "runserver", "0.0.0.0:8000"]
