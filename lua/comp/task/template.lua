return
{
    c =
    {
        run =
        {
            {
                title = "Gcc",
                cmd = [[gcc "$filepath" -o "$filename.exe" ; ./"$filename.exe" ; $delete "$filename.exe"]]
            },
            {
                title = "Clang",
                cmd = [[clang "$filepath" -o "$filename.exe" ; ./"$filename.exe" ; $delete "$filename.exe"]]
            }
        },
        build =
        {
            {
                title = "Cmake",
                cmd = [[mkdir build ; cd build ; cmake .. ; cmake --build .]]
            },
            {
                title = "MSBuild",
                cmd = [[msbuild $projname.sln /p:Configuration=Release ]]
            }
        }
    },
    cpp =
    {
        run =
        {
            {
                title = "G++",
                cmd = [[g++ "$filepath" -O2 -g -Wall -o "$filename.exe" ; ./"$filename.exe" ; $delete "$filename.exe"]]
            },
            {
                title = "clang++",
                cmd = [[clang++ "$filepath" -O2 -g -Wall -o "$filename.exe" ; ./"$filename.exe" ; $delete "$filename.exe"]]
            }
        },
        build =
        {
            {
                title = "Cmake",
                cmd = [[mkdir build ; cd build ; cmake .. ; cmake --build .]]
            },
            {
                title = "MSBuild",
                cmd = [[msbuild $projname.sln /p:Configuration=Release]]
            }
        }
    },
    cs =
    {
        run =
        {
            {
                title = "Debug",
                cmd = [[dotnet run --configuration Debug]]
            },
            {
                title = "Release",
                cmd = [[dotnet run --configuration Release]]
            },
            {
                title = "Script",
                cmd = [[dotnet script "$filepath"]]
            },
            {
                title = "Single",
                cmd = [[dotnet run "$filepath"]]
            }
        },
        build =
        {
            {
                title = "Debug",
                cmd = [[dotnet build --configuration Debug]]
            },
            {
                title = "Release",
                cmd = [[dotnet build --configuration Release]]
            }
        }
    },
    fsharp =
    {
        run =
        {
            {
                title = "Debug",
                cmd = [[dotnet run --configuration Debug]]
            },
            {
                title = "Release",
                cmd = [[dotnet run --configuration Release]]
            },
            {
                title = "Script",
                cmd = [[dotnet script "$filepath"]]
            },
            {
                title = "Script",
                cmd = [[dotnet run "$filepath"]]
            }
        },
        build =
        {
            {
                title = "Debug",
                cmd = [[dotnet build --configuration Debug]]
            },
            {
                title = "Release",
                cmd = [[dotnet build --configuration Release]]
            }
        }
    },
    go =
    {
        run =
        {
            {
                title = "Go",
                cmd = [[go run "$filepath"]]
            }
        },
        build =
        {
            {
                title = "Debug",
                cmd = [[go build -gcflags="all=-N -l" -o $projname-debug]]
            },
            {
                title = "Release",
                cmd = [[go build -ldflags="-s -w" -o $projname-release]]
            }
        }
    },
    java =
    {
        run =
        {
            {
                title = "Gradle",
                cmd = [[./gradlew run]]
            },
            {
                title = "Maven",
                cmd = [[mvn package exec:java]]
            },
            {
                title = "Script",
                cmd = [[javac "$filepath" ; java "$filename" ; $delete "$filename.class"]]
            }
        },
        build =
        {
            {
                title = "Javac",
                cmd = [[javac *.java]]
            },
            {
                title = "Maven",
                cmd = [[mvn clean install]]
            },
            {
                title = "Gradle",
                cmd = [[./gradlew clean build]]
            }
        }
    },
    javascript =
    {
        run =
        {
            {
                title = "Node",
                cmd = [[node --trace-warnings "$filepath"]]
            }
        },
        build =
        {
            {
                title = "Npm",
                cmd = [[npm run build]]
            },
            {
                title = "Webpack",
                cmd = [[npx webpack]]
            },
            {
                title = "Vite",
                cmd = [[npx vite build]]
            },
            {
                title = "Parcel",
                cmd = [[npx parcel build index.html]]
            },
        }
    },
    typescript =
    {
        run =
        {
            {
                title = "Node",
                cmd = [[node --trace-warnings "$filepath"]]
            }
        },
        build =
        {
            {
                title = "Node",
                cmd = [[npm run build]]
            },
            {
                title = "Webpack",
                cmd = [[npx webpack]]
            },
            {
                title = "Vite",
                cmd = [[npx vite build]]
            },
            {
                title = "Parcel",
                cmd = [[npx parcel build index.html]]
            },
        }
    },
    php =
    {
        run =
        {
            {
                title = "Php",
                cmd = [[php "$filepath"]]
            }
        }
    },
    python =
    {
        run =
        {
            {
                title = "Python",
                cmd = [[python "$filepath"]]
            }
        },
        build =
        {
            {
                title = "PyInstaller",
                cmd = [[pyinstaller --onefile "$filepath"]]
            }
        }
    },
    ruby =
    {
        run =
        {
            title = "Ruby",
            cmd = [[ruby $filepath]]
        },
        build =
        {
            {
                title = "Ocra",
                cmd = [[ocra "$filepath" --windows --add-all-core --output "$projname.exe"]]
            },
            {
                title = "Ruby-Packer",
                cmd = [[rubyc "$filepath" --output "$projname" --platform windows]]
            }
        }
    },
    rust =
    {
        run =
        {
            {
                title = "Rustc",
                cmd = [[rustc "$filepath" ; ./"$filename" ; $delete "$filename"]]
            }
        },
        build =
        {
            {
                title = "Debug",
                cmd = [[cargo build]]
            },
            {
                title = "Release",
                cmd = [[cargo build --release]]
            }
        }
    },
    lua =
    {
        run =
        {
            {
                title = "Luajit",
                cmd = [[luajit "$filepath"]]
            }
        }
    },
    zig =
    {
        run =
        {
            {
                title = "Zig",
                cmd = [[zig run "$filepath"]]
            }
        },
        build =
        {
            {
                title = "Debug",
                cmd = [[zig build]]
            },
            {
                title = "ReleaseSafe",
                cmd = [[zig build -Doptimize=ReleaseSafe]]
            },
            {
                title = "ReleaseFast",
                cmd = [[zig build -Doptimize=ReleaseFast]]
            },
            {
                title = "ReleaseSmall",
                cmd = [[zig build -Doptimize=ReleaseFast]]
            }
        }
    },
    odin =
    {
        run =
        {
            {
                title = "Project",
                cmd = [[odin run "$projpath"]]
            },
            {
                title = "Script",
                cmd = [[odin run "$filepath" -file]]
            }
        },
        build =
        {
            {
                title = "Default",
                cmd = [[odin build "$projpath" -o:none]]
            },
            {
                title = "Minimal",
                cmd = [[odin build "$projpath" -o:minimal]]
            },
            {
                title = "Size",
                cmd = [[odin build "$projpath" -o:size]]
            },
            {
                title = "Speed",
                cmd = [[odin build "$projpath" -o:speed]]
            },
            {
                title = "Aggressive",
                cmd = [[odin build "$projpath" -o:aggressive]]
            }
        }
    },
    v =
    {
        run =
        {
            {
                title = "Project",
                cmd = [[v run "$projpath"]]
            },
            {
                title = "Script",
                cmd = [[v run "$filepath"]]
            }
        },
        build =
        {
            {
                title = "Dev",
                cmd = [[v "$projpath"]]
            },
            {
                title = "Dev-Parallel-cc",
                cmd = [[v -parallel-cc "$projpath"]]
            },
            {
                title = "Product",
                cmd = [[v -prod "$projpath"]]
            },
            {
                title = "Product-Parallel-cc",
                cmd = [[v -prod -parallel-cc "$projpath"]]
            },
            {
                title = "C",
                cmd = [[v -o "$filename.c" "$projpath"]]
            },
            {
                title = "Javascript",
                cmd = [[v -b js "$projpath"]]
            }
        }
    },
    moonbit =
    {
        run =
        {
            {
                title = "Project",
                cmd = [[moon run "$projpath"]]
            },
            {
                title = "Script",
                cmd = [[ocaml run "$filepath"]]
            }
        },
        build =
        {
            {
                title = "Debug",
                cmd = [[moon build]]
            },
            {
                title = "Release",
                cmd = [[moon build --release]]
            }
        }
    },
    ocaml =
    {
        run =
        {
            {
                title = "Project",
                cmd = [[dune build; dune exec "$projname"]]
            },
            {
                title = "Script",
                cmd = [[ocaml "$filepath"]]
            }
        },
        build =
        {
            {
                title = "Dune",
                cmd = [[dune build]]
            },
            {
                title = "OcamlBuild",
                cmd = [[ocamlbuild "$filename.native"]]
            }
        }
    },
    haskell =
    {
        run =
        {
            {
                title = "GHC",
                cmd = [[ghc "$filepath"]]
            },
            {
                title = "Stack",
                cmd = [[stack "$filepath"]]
            },
            {
                title = "Cabal",
                cmd = [[cabal run "$filepath"]]
            }
        },
        build =
        {
            {
                title = "Stack",
                cmd = [[stack run]]
            },
            {
                title = "Cabal",
                cmd = [[cabal run]]
            }
        }
    },
    scheme =
    {
        run =
        {
            {
                title = "Guile",
                cmd = [[guile "$filepath"]]
            },
            {
                title = "Racket",
                cmd = [[racket "$filepath"]]
            },
            {
                title = "Chez",
                cmd = [[scheme --script "$filepath"]]
            },
            {
                title = "Gambit",
                cmd = [[gsi "$filepath"]]
            },
            {
                title = "Chicken",
                cmd = [[csi -script "$filepath"]]
            },
            {
                title = "Gauche",
                cmd = [[gosh "$filepath"]]
            },
            {
                title = "Chibi",
                cmd = [[chibi-scheme -l "$filepath"]]
            },
            {
                title = "MIT",
                cmd = [[mit-scheme --load "$filepath"]]
            }
        },
        build =
        {
            {
                title = "Guile",
                cmd = [[guile -c '((@ (system base compile) compile-file) "$filepath")']]
            },
            {
                title = "Racket",
                cmd = [[raco distribute "$projname" "$filename.rkt"]]
            },
            {
                title = "Chez",
                cmd = [[scheme --exe "$filename" "$filepath"]]
            },
            {
                title = "Gambit",
                cmd = [[gsc -exe -o "$filename" "$filepath"]]
            },
            {
                title = "Chicken",
                cmd = [[csc "$filepath"]]
            },
            {
                title = "Gauche",
                cmd = [[gauche-package build-standalone -o "$projname" "$filepath"}]]
            },
            {
                title = "Bigloo",
                cmd = [[bigloo -o "$projname" "$filepath"}]]
            }
        }
    },
    lisp =
    {
        run =
        {
            {
                title = "SBCL",
                cmd = [[sbcl --script "$filepath"]]
            },
            {
                title = "CLISP",
                cmd = [[clisp "$filepath"]]
            },
            {
                title = "ECL",
                cmd = [[ecl -shell "$filepath"]]
            },
            {
                title = "ROS",
                cmd = [[ros run -s "$filepath"]]
            }
        },
        build =
        {
            {
                title = "SBCL",
                cmd = [[sbcl --load "$filepath" --eval '(sb-ext:save-lisp-and-die "$filename" :toplevel #'main :executable t)']]
            },
            {
                title = "CLISP",
                cmd = [[clisp -x '(progn (load "$filename") (saveinitmem "$filename" :init-function #'main :executable t))']]
            },
            {
                title = "ECL",
                cmd = [[ecl -eval '(c:build-program "$filename" :lisp-files (list "your-program.o") :init-function #'main)']]
            }
        }
    },
    coq =
    {
        run =
        {
            {
                title = "Coqc",
                cmd = [[coqc "$filepath"]]
            },
            {
                title = "Coqtop",
                cmd = [[coqtop -l "$filepath"]]
            }
        },
        build =
        {
            {
                title = "Makefile",
                cmd = [[make]]
            },
            {
                title = "Dune",
                cmd = [[dune build]]
            }
        }
    },
    agda =
    {
        run =
        {
            {
                title = "Agda",
                cmd = [[agda "$filepath" ; agda --compile "$filepath" ; ./"$filename" || "./$filename.exe" ; $delete "./$filename" || $delete "./$filename.exe"]]
            },
            {
                title = "Agda-CLI",
                cmd = [[agda-cli run "$filepath"]]
            },
        },
        build =
        {
            {
                title = "Executable",
                cmd = [[agda --compile "$filepath"]]
            },
            {
                title = "Html",
                cmd = [[agda --html "$filepath"]]
            }
        }
    },
    lean =
    {
        run =
        {
            {
                title = "Script",
                cmd = [[lean --run "$filepath"]]
            },
            {
                title = "Project",
                cmd = [[Lake run]]
            },
        },
        build =
        {
            {
                title = "Lake",
                cmd = [[lake -d "$projpath" build]]
            }
        }
    },
    swift =
    {
        run =
        {
            {
                title = "Project",
                cmd = [[swift run]]
            },
            {
                title = "Script",
                cmd = [[swift "$filepath"]]
            }
        },
        build =
        {
            {
                title = "Debug",
                cmd = [[swift build -c debug]]
            },
            {
                title = "Release",
                cmd = [[swift build -c release]]
            }
        }
    },
    kotlin =
    {
        run =
        {
            {
                title = "Gradle",
                cmd = [[./gradlew run]]
            },
            {
                title = "Maven",
                cmd = [[mvn package exec:java]]
            },
            {
                title = "Script",
                cmd = [[kotlin "$filepath"]]
            }
        },
        build =
        {
            {
                title = "Maven",
                cmd = [[mvn clean install]]
            },
            {
                title = "Gradle",
                cmd = [[./gradlew clean build]]
            }
        }
    },
    sh =
    {
        run =
        {
            {
                title = "Bash",
                cmd = [[bash "$filepath"]]
            }
        }
    },
    dosbatch =
    {
        run =
        {
            {
                title = "Cmd",
                cmd = [[cmd /c ./"$filepath"]]
            },
            {
                title = "Wine",
                cmd = [[chmod +x "$filepath" ; wine ./"$filepath"]]
            }
        }
    },
    ps1 =
    {
        run =
        {
            {
                title = "Powershell",
                cmd = [[powershell -File "$filepath"]]
            },
            {
                title = "Pwsh",
                cmd = [[chmod +x "$filepath" ; pwsh -File "$filepath"]]
            }
        }
    },
    markdown =
    {
        run =
        {
            {
                title = "Glow",
                cmd = [[glow "$filepath"]]
            },
            {
                title = "Mdcat",
                cmd = [[mdcat -p "$filepath"]]
            },
            {
                title = "Hike",
                cmd = [[hike "$filepath"]]
            },
            {
                title = "Slides",
                cmd = [[slides "$filepath"]]
            },
            {
                title = "Frogmouth",
                cmd = [[frogmouth "$filepath"]]
            },
            {
                title = "Markless",
                cmd = [[markless "$filepath"]]
            },
            {
                title = "Powershell",
                cmd = [[Show-Markdown -Path "$filepath"]]
            },
            {
                title = "SMD",
                cmd = [[smd "$filepath"]]
            }
        }
    },
    html =
    {
        run =
        {
            {
                title = "W3M",
                cmd = [[w3m "$filepath"]]
            },
            {
                title = "Lynx",
                cmd = [[lynx "$filepath"]]
            },
            {
                title = "Elinks",
                cmd = [[elinks "$filepath"]]
            },
            {
                title = "Links2",
                cmd = [[links2 "$filepath"]]
            },
            {
                title = "Default",
                cmd = [[xdg-open "$filepath"]]
            },
            {
                title = "Explorer",
                cmd = [[powershell start "$filepath"]]
            }
        }
    }
}
