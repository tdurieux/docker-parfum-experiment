# Ignore everything
**

# Include this service's source
!feature-gate/src
!feature-gate/Cargo.lock
!feature-gate/Cargo.toml
!feature-gate/build.rs
!feature-gate/config.default.toml

# Include protobuf definitions
!lib/proto/feature-gate.proto

# Include config-backoff-rs