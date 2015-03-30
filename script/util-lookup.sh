function lookup_extension() {
    local target="${1}"
    case "${target}" in
        c         ) echo c ;;
        clojure   ) echo clj ;;
        coffee    ) echo coffee ;;
        cpp       ) echo cpp ;;
        csharp    ) echo cs ;;
        d         ) echo d ;;
        erlang    ) echo erl ;;
        fsharp    ) echo fs ;;
        go        ) echo go ;;
        groovy    ) echo groovy ;;
        haskell   ) echo hs ;;
        java      ) echo java ;;
        node      ) echo js ;;
        lisp      ) echo lisp ;;
        objc      ) echo m ;;
        ocaml     ) echo ml ;;
        perl      ) echo pl ;;
        php       ) echo php ;;
        python    ) echo py ;;
        ruby      ) echo rb ;;
        racket    ) echo rkt ;;
        rust      ) echo rs ;;
        scala     ) echo scala ;;
        bash      ) echo sh ;;
    esac
}

function lookup_full_name() {
    local target="${1}"
    case "${target}" in
        c         ) echo C ;;
        clojure   ) echo Clojure ;;
        coffee    ) echo CoffeeScript ;;
        cpp       ) echo C++ ;;
        csharp    ) echo C# ;;
        d         ) echo D ;;
        erlang    ) echo Erlang ;;
        fsharp    ) echo F# ;;
        go        ) echo Go ;;
        groovy    ) echo Groovy ;;
        haskell   ) echo Haskell ;;
        java      ) echo Java ;;
        node      ) echo NodeJS ;;
        lisp      ) echo Lisp ;;
        objc      ) echo Objective C ;;
        ocaml     ) echo OCaml ;;
        perl      ) echo Perl ;;
        php       ) echo PHP ;;
        python    ) echo Python ;;
        ruby      ) echo Ruby ;;
        racket    ) echo Racket ;;
        rust      ) echo Rust ;;
        scala     ) echo Scala ;;
        bash      ) echo Bash ;;
    esac
}

function lookup_image_types() {
    local target="${1}"
    case "${target}" in
        base-c ) echo 'C family languages' ;;
        base-jdk ) echo 'JDK languages' ;;
        base-mono ) echo '.net languages' ;;
        base-node ) echo 'Node JS languages' ;;
    esac
}