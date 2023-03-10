# Ignore everything
**

# Include this service's source
!logs/submission/src
!logs/submission/Cargo.lock
!logs/submission/Cargo.toml
!logs/submission/build.rs
!logs/submission/config.default.toml

# Include protobuf definitions
!lib/proto/logs/event.proto
!lib/proto/logs/submission.proto

# Include config-backoff-rs
!lib/config-backoff-rs/src
!lib/config-backoff-rs/Cargo.toml

# Include logs/submission/schema