FROM golang:1.16

# Compile the tests during build to save time during testing.
RUN ["go", "tool", "dist", "test", "-compile-only"]