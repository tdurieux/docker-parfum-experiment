FROM socialwifi/kubeyard-python:3.7.0-0
ENV DJANGO_SETTINGS_MODULE={{ UNDERSCORED_PROJECT_NAME }}.settings
CMD ["start_service"]