# This Dockerfile can be used to deploy a production instance
# to Heroku.
#
# It builds upon the image in the base Dockerfile, adding
# extra directives to install all dependencies, generate static
# assets, and so forth, so that the final container is completely
# self-contained.

FROM justfixnyc/tenants2_base:0.10

# The way we're using lots of layers here is intentional, as
# we're first installing our dependencies--which don't change
# very often--and then copying over the rest of our source code,
# which does change often. This means we can iterate faster
# because we e.g. don't have to re-install all our dependencies
# if we change a single line of code (it also reduces the amount
# of data we need to transfer to send our image somewhere, if
# the destination already has cached layers from previous
# builds we've sent).

ENV NODE_ENV=production

COPY Pipfile* requirements.production.txt /var/tenants2/

WORKDIR /var/tenants2

RUN pipenv install --system --keep-outdated \
  && pip install --no-cache-dir -r requirements.production.txt \
  && rm -rf ~/.cache

WORKDIR /tenants2

# This contains the fake version of a npm module that we need on the
# filesystem so yarn can install dependencies. For more details, see
# https://github.com/JustFixNYC/tenants2/pull/1661.
COPY frontend/fake-opencollective /tenants2/frontend/fake-opencollective

COPY package.json yarn.lock /tenants2/

# Make sure we run as a non-root user.
RUN useradd -m myuser
RUN chown myuser /tenants2
USER myuser

RUN yarn install --frozen-lockfile \
  && yarn cache clean && yarn cache clean;

ADD --chown=myuser:myuser . /tenants2/

ARG GIT_REVISION
ARG IS_GIT_REPO_PRISTINE

ENV GIT_REVISION=$GIT_REVISION
ENV IS_GIT_REPO_PRISTINE=$IS_GIT_REPO_PRISTINE

RUN yarn build \
  && python manage.py collectstatic \
  && python manage.py compilemessages && yarn cache clean;

CMD gunicorn --bind 0.0.0.0:$PORT project.wsgi
