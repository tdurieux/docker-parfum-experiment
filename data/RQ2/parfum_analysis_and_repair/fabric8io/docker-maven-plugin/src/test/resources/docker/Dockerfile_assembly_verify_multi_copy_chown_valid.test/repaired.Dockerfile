FROM image
COPY --chown=app deps/* ./
COPY --chown=app maven/* ./