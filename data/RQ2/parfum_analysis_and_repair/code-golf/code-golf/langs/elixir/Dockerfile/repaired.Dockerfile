# FIXME Using alpine causes a 5s timeout with no net, musl DNS???
# <1s docker run --rm --net none elixir:slim
# >5s docker run --rm --net none elixir:alpine