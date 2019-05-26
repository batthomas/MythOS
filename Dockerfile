FROM ubuntu:latest

RUN apt-get update

RUN apt-get install -qq -y --no-install-recommends \
    git      \
    gcc      \
    binutils \
    make     \
    nasm     \
    qemu-system-x86 

ENTRYPOINT [ "bash" ]