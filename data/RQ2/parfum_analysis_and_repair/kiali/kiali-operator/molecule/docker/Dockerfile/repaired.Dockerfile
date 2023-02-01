FROM quay.io/ansible/creator-ee:v0.5.2
ENV PACKAGES="\
openssl \
"
RUN dnf install -y ${PACKAGES}
RUN pip install --no-cache-dir jmespath
RUN ansible-galaxy collection install community.general kubernetes.core
RUN curl -f -L https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash && helm version
