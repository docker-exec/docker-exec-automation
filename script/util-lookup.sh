#!/bin/bash

function lookup_extension() {
    local target="${1}"
    case "${target}" in
        c         ) echo "c" ;;
        clojure   ) echo "clj" ;;
        coffee    ) echo "coffee" ;;
        cpp       ) echo "cpp" ;;
        csharp    ) echo "cs" ;;
        d         ) echo "d" ;;
        erlang    ) echo "erl" ;;
        fsharp    ) echo "fs" ;;
        go        ) echo "go" ;;
        groovy    ) echo "groovy" ;;
        haskell   ) echo "hs" ;;
        java      ) echo "java" ;;
        node      ) echo "js" ;;
        lisp      ) echo "lisp" ;;
        lua       ) echo "lua" ;;
        objc      ) echo "m" ;;
        ocaml     ) echo "ml" ;;
        nim       ) echo "nim" ;;
        perl      ) echo "pl" ;;
        perl6     ) echo "p6" ;;
        php       ) echo "php" ;;
        python    ) echo "py" ;;
        python2   ) echo "py" ;;
        r         ) echo "r" ;;
        ruby      ) echo "rb" ;;
        racket    ) echo "rkt" ;;
        rust      ) echo "rs" ;;
        scala     ) echo "scala" ;;
        bash      ) echo "sh" ;;
        *         ) echo "${target}" ;;
    esac
}

function lookup_full_name() {
    local target="${1}"
    case "${target}" in
        c         ) echo "C" ;;
        clojure   ) echo "Clojure" ;;
        coffee    ) echo "CoffeeScript" ;;
        cpp       ) echo "C++" ;;
        csharp    ) echo "C#" ;;
        d         ) echo "D" ;;
        erlang    ) echo "Erlang" ;;
        fsharp    ) echo "F#" ;;
        go        ) echo "Go" ;;
        groovy    ) echo "Groovy" ;;
        haskell   ) echo "Haskell" ;;
        java      ) echo "Java" ;;
        node      ) echo "NodeJS" ;;
        lisp      ) echo "Lisp" ;;
        lua       ) echo "Lua" ;;
        objc      ) echo "Objective C" ;;
        ocaml     ) echo "OCaml" ;;
        nim       ) echo "Nim" ;;
        perl      ) echo "Perl" ;;
        perl6     ) echo "Perl 6" ;;
        php       ) echo "PHP" ;;
        python    ) echo "Python 3" ;;
        python2   ) echo "Python 2" ;;
        r         ) echo "R" ;;
        ruby      ) echo "Ruby" ;;
        racket    ) echo "Racket" ;;
        rust      ) echo "Rust" ;;
        scala     ) echo "Scala" ;;
        bash      ) echo "Bash" ;;
        *         ) echo "${target}" ;;
    esac
}

function lookup_image_types() {
    local target="${1}"
    case "${target}" in
        base-c ) echo "C family languages" ;;
        base-jdk ) echo "JDK languages" ;;
        base-mono ) echo ".net languages" ;;
        base-node ) echo "Node JS languages" ;;
        base-python ) echo "Python 2 \& 3" ;;
    esac
}
