# syntax=docker/dockerfile:1

FROM ubuntu:24.10 AS base

RUN apt-get update \
    && apt-get upgrade -y

FROM base AS builder

RUN apt-get install -y opam

# --disable-sandboxing is needed due to bwrap: No permissions to creating new namespace error
RUN opam init --bare -a -y --disable-sandboxing && opam update

RUN opam switch create default ocaml-base-compiler.5.2.0

WORKDIR /app

COPY dune-project dune  *.opam ./

# install opam packages' system dependencies
RUN opam install . --depext-only --yes --confirm-level=unsafe-yes

# install project opam packages
RUN opam install . --deps-only --assume-depexts --yes

COPY main.ml ./

# eval $(opam config env) adds dune to PATH
RUN eval $(opam config env) && dune build main.exe

CMD [ "dune" "exec" "project_name" ]

FROM base as dev

RUN apt-get install -y opam

# --disable-sandboxing is needed due to bwrap: No permissions to creating new namespace error
RUN opam init --bare -a -y --disable-sandboxing && opam update

RUN opam switch create default ocaml-base-compiler.5.2.0

RUN opam install dune -y