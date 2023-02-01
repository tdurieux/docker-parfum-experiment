# Following stage must be picked from cache
FROM busybox as one
RUN echo hello
RUN echo hello > world

# Following stage must be picked from cache except last instruction