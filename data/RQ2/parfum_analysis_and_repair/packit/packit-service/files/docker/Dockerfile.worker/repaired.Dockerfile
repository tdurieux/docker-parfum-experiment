# Celery worker which runs tasks (packit) from the web service

FROM quay.io/packit/base

ARG SOURCE_BRANCH
RUN  if [[ -z $SOURCE_BRANCH ]]; then \
echo -e "\nMissing SOURCE_BRANCH build argument! Please add \
\"--build-arg SOURCE_BRANCH=<val>\" to the build command to specify it!\n\
This is the branch used when installing other Packit projects (e.g. ogr, packit).\n" && exit 1;\
fi

ENV USER=packit \
    HOME=/home/packit

# Ansible doesn't like /tmp
WORKDIR /src

COPY files/ ./files/
RUN ansible-playbook -vv -c local -i localhost, files/install-deps-worker.yaml \
    && dnf clean all

COPY setup.* .git_archival.txt .gitattributes ./
# setuptools-scm
COPY .git/ .git/
COPY packit_service/ packit_service/

RUN git rev-parse HEAD >/.packit-service.git.commit.hash \
    && git show --quiet --format=%B HEAD >/.packit-service.git.commit.message \
    && ansible-playbook -vv -c local -i localhost, files/recipe-worker.yaml \
    && rm -rf /src/*
# /src content is no longer needed, clean it for 'hardly'