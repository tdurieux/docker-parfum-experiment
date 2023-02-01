FROM envoyproxy/envoy-build-ubuntu:514e2f7bc36c1f0495a523b16aab9168a4aa13b6 as builder

RUN git clone --single-branch --branch qat-provider-main-oot-v6 https://github.com/ipuustin/envoy.git envoy

WORKDIR /envoy

RUN apt-get update && apt-get install --no-install-recommends -y gettext yasm && rm -rf /var/lib/apt/lists/*;

RUN bazel build --copt="-mcx16" --cxxopt="-mcx16" -c opt //contrib/exe:envoy-static --//contrib/vcl/source:enabled=false

RUN install -D /envoy/LICENSE /tmp/install_root/usr/local/share/package-licenses/envoy/LICENSE
RUN install -D /envoy/bazel-bin/contrib/exe/envoy-static /tmp/install_root/usr/local/bin/envoy-static

# generate entrypoint script
RUN echo "#!/bin/sh\n" \
         "set -e\n" \
         "/usr/bin/envsubst < /etc/envoy/config/envoy-conf.yaml > /tmp/envoy-conf.yaml\n" \
         "/usr/local/bin/envoy-static -c /tmp/envoy-conf.yaml \$@\n" > /entrypoint.sh

RUN install -m 755 -D /entrypoint.sh /tmp/install_root/usr/local/bin/entrypoint.sh
RUN install -D /usr/bin/envsubst /tmp/install_root/usr/bin/envsubst

FROM ubuntu:focal as final
COPY --from=builder /tmp/install_root /

ENV PATH=/usr/local/bin
ENV QAT_SECTION_NAME SHIM
ENV POLL_DELAY 0.005s

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
