FROM python:3.9-slim-bullseye as opcut-base
WORKDIR /opcut
RUN apt update -qy && \
    apt install --no-install-recommends -qy pkg-config gcc libcairo2-dev && rm -rf /var/lib/apt/lists/*;

FROM opcut-base as opcut-build
WORKDIR /opcut
COPY . .
RUN apt install --no-install-recommends -qy nodejs yarnpkg git gcc-mingw-w64-x86-64-win32 && \
    ln -sT /usr/bin/yarnpkg /usr/bin/yarn && \
    ln -sT /usr/bin/x86_64-w64-mingw32-gcc /usr/bin/x86_64-w64-mingw32-cc && \
    pip install --no-cache-dir -qq -r requirements.pip.dev.txt && \
    doit && rm -rf /var/lib/apt/lists/*;

FROM opcut-base as opcut-run
WORKDIR /opcut
COPY --from=opcut-build /opcut/build/py/dist/*.whl .
RUN pip install --no-cache-dir -qq *.whl && \
    rm *.whl
