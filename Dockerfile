FROM rust:1.56-alpine AS builder

RUN apk add alpine-sdk autoconf clang clang-static linux-headers

WORKDIR /app
COPY . /app

# RUN cargo build --release
RUN RUSTFLAGS="-C target-feature=-crt-static" cargo build --release
RUN strip ./target/release/sonic

FROM rust:1.56-alpine

WORKDIR /usr/src/sonic

COPY --from=builder /app/target/release/sonic /usr/local/bin/sonic

CMD [ "sonic", "-c", "/etc/sonic.cfg" ]

EXPOSE 1491
