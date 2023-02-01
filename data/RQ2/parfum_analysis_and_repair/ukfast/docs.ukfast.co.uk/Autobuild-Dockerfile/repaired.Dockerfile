FROM python:3.8-alpine

RUN pip install --no-cache-dir recommonmark sphinx-autobuild
RUN apk add --no-cache make

EXPOSE 8000
WORKDIR /build

ENTRYPOINT [ "sphinx-autobuild" ]
CMD [ \
    "--pre-build", "make build/html/_static/css/app.css", \
    "--pre-build", "make build/html/_static/app.js", \
    "--host", "0.0.0.0", \
    "source", \
    "build/html" \
]
