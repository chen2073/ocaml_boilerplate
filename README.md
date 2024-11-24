# OCaml Boilerplate
Helps you get started building ocaml program quickly for beginners

## Steps
1. Clone this repo
2. Change folder name to you project name
3. change dune file `project_name` to your project name
4. add your dependencies manually in dune file's libraries by appending after `eio`
5. change dune-project's package to your project name
6. add your dependencies manually in dune-project file's by appending after `ocaml dune eio_main`
7. change filename of project_name.opam to your `{your_project_name}.opam`

## Run it locally
1. have ocaml, opam, dune all installed on your local machine
2. run `dune build`
3. run `dune exec {your_project_name}`

## Run it in Docker
1. Have Docker installed on your machine
2. run `docker compose build`. (Make sure dune, dune-project, {you_project_name}.opam all reflect the latest dependencies, dune build updates .opam file)
3. run `docker compose up` or `docker compose run --rm app`

## Run dev environment in Docker
1. run `docker compose run --rm dev bash`
2. run `opam install .` interactively
3. run `eval $(opam env)`
3. run `dune build`
4. run `dune exec {your_project_name}`

## Editor setup
vscode - OCaml Platform extension