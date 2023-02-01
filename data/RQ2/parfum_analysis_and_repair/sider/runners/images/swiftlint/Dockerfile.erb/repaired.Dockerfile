FROM sider/devon_rex_swift:2.46.0

<%= render_erb 'images/Dockerfile.base.erb' %>

ARG SWIFTLINT_VERSION=0.47.1

# Build SwiftLint
RUN cd /tmp && \
    curl -f -sSL --compressed "https://github.com/realm/SwiftLint/archive/${SWIFTLINT_VERSION}.tar.gz" | tar -xz && \
    cd "SwiftLint-${SWIFTLINT_VERSION}" && \
    make build_x86_64 "SWIFT_BUILD_FLAGS=--configuration release" && \
    cp $(swift build --arch x86_64 --configuration release --show-bin-path)/swiftlint ${RUNNER_USER_BIN} && \
    cd .. && \
    rm -rf "SwiftLint-${SWIFTLINT_VERSION}" && \
    swiftlint version | grep "${SWIFTLINT_VERSION}"

<%= render_erb 'images/Dockerfile.end.erb' %>
