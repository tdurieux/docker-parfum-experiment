# Build
FROM python:3-alpine
WORKDIR /a
COPY setup.py .
COPY cloudkeeper cloudkeeper
RUN python setup.py bdist_wheel

# Run