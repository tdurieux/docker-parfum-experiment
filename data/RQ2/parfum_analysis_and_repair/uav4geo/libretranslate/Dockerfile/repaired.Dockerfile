FROM python:3.8.12-slim-bullseye

ARG with_models=false
ARG models=

WORKDIR /app

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq \
  && apt-get -qqq install --no-install-recommends -y libicu-dev pkg-config gcc g++ \
  && apt-get clean \
  && rm -rf /var/lib/apt && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip

COPY . .


RUN if [ "$with_models" = "true" ]; then \
        pip install --no-cache-dir -e .; \

        if [ ! -z "$models" ]; then \
                  ./install_models.py --load_only_lang_codes "$models";   \
        else \
                  ./install_models.py;  \
        fielse \
                  ./install_models.py;  \
        fi \
    fi
# Install package from source code
RUN pip install --no-cache-dir . \
  && pip cache purge

EXPOSE 5000
ENTRYPOINT [ "libretranslate", "--host", "0.0.0.0" ]
