FROM quay.io/operator-framework/helm-operator:v0.6.0

COPY helm-charts/ ${HOME}/helm-charts/
COPY watches.yaml ${HOME}/watches.yaml