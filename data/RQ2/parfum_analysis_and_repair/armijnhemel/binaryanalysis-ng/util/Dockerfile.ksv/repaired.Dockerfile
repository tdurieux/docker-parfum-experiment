FROM kaitai

RUN apt-get update && apt-get install --no-install-recommends -y rubygems && rm -rf /var/lib/apt/lists/*;

ENV PATH="/kaitai_struct/visualizer/bin:/kaitai-struct-compiler/bin:${PATH}"

ENTRYPOINT []
CMD ["ksv"]

