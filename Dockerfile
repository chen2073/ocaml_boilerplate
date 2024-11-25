# syntax=docker/dockerfile:1

FROM ubuntu:24.10 AS base

FROM base AS opam

RUN apt-get update \
    && apt-get upgrade -y

RUN apt-get install -y opam

# --disable-sandboxing is needed due to bwrap: No permissions to creating new namespace error
RUN opam init --bare -a -y --disable-sandboxing && opam update

RUN opam switch create default ocaml-base-compiler.5.2.0

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
