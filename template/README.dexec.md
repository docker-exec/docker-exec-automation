# Docker Exec Image: {{image-full-name}}

A Dockerfile describing an container capable of executing {{image-full-name}} source files.

# Build

```sh
git clone https://github.com/docker-exec/{{image-name}}.git
docker build -t dexec/lang-{{image-name}} .
```

# Usage

In a directory containing a script e.g. foo.{{file-extension}}, run:

```sh
docker run -t --rm \
    -v $(pwd -P)/foo.{{file-extension}}:/tmp/dexec/build/foo.{{file-extension}} \
    dexec/lang-{{image-name}} foo.{{file-extension}}
```

## Passing arguments to the script

Arguments can be passed to the script using any of the following forms:

```
-a argument
--arg argument
--arg=argument
```

Each argument passed must be prefixed in this way, e.g.

```sh
docker run -t --rm \
    -v $(pwd -P)/foo.{{file-extension}}:/tmp/dexec/build/foo.{{file-extension}} \
    dexec/lang-{{image-name}} foo.{{file-extension}} \
    --arg='hello world' \
    --arg=foo \
    --arg=bar
```
{{start-compiled-only}}

## Passing arguments to the compiler

Arguments can be passed to the compiler using any of the following forms:

```
-b argument
--build-arg argument
--build-arg=argument
```

Each argument passed must be prefixed in this way, e.g.

```sh
docker run -t --rm \
    -v $(pwd -P)/foo.{{file-extension}}:/tmp/dexec/build/foo.{{file-extension}} \
    dexec/lang-{{image-name}} foo.{{file-extension}} \
    --build-arg=-some-compiler-option \
    --build-arg=some-compiler-option-value
```
{{end-compiled-only}}
