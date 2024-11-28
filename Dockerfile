# syntax=docker/dockerfile:1

# ubuntu os version
ARG OS_VERSION=24.10
# ocaml compiler version
ARG COMPILER_VERSION=ocaml-base-compiler.5.2.0
# opam switch name
ARG OPAM_SWITCH=default

FROM ubuntu:${OS_VERSION} AS base

FROM base AS opam

ARG COMPILER_VERSION
ARG OPAM_SWITCH

RUN apt-get update \
    && apt-get upgrade -y

RUN apt-get install -y opam

# --disable-sandboxing is needed due to bwrap: No permissions to creating new namespace error
RUN opam init --bare -a -y --disable-sandboxing && opam update

RUN opam switch create ${OPAM_SWITCH} ${COMPILER_VERSION}

FROM opam AS builder

WORKDIR /app

COPY dune-project dune  *.opam ./

# install opam packages' system dependencies
RUN opam install . --depext-only --yes --confirm-level=unsafe-yes

# install project opam packages
RUN opam install . --deps-only --assume-depexts --yes

COPY main.ml ./

# opam exec is needed since dune is added to PATH
RUN opam exec dune build main.exe

CMD [ "opam" "exec" "dune" "exec" "project_name" ]

FROM opam AS dev

RUN opam install dune -y
