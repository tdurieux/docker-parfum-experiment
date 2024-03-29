FROM sysstacks/dlrs-pytorch-clearlinux:v0.6.0-oss

WORKDIR /workdir/website
COPY website/ /workdir/website/

EXPOSE 5000

SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["python", "app.py"]