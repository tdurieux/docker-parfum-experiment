FROM opentracing/nginx-opentracing
RUN apt update && apt -y --no-install-recommends install curl jq && rm -rf /var/lib/apt/lists/*;
COPY install-dd-opentracing-cpp /
RUN /install-dd-opentracing-cpp
