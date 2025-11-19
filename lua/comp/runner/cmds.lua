return
{
    c          = { cmd = {[[gcc "$file" -o "$exename.exe" ; ./"$exename.exe" ; $delete "$exename.exe" ]]}},
    cpp        = { cmd = {[[g++ "$file" -O2 -g -Wall -o "$exename.exe" ; ./"$exename.exe" ; $delete "$exename.exe" ]]}},
    cs         = { cmd = {[[dotnet run]], [[dotnet run "$file"]], [[dotnet script "$file" ]]}},
    go         = { cmd = {[[go run "$file"]]}},
    java       = { cmd = {[[javac "$file" ; java "$exename" ; $delete "$exename.class" ]]}},
    javascript = { cmd = {[[node --trace-warnings "$file" ]]}},
    php        = { cmd = {[[php "$file" ]]}},
    python     = { cmd = {[[python3 "$file" ]]}},
    ruby       = { cmd = {[[ruby $file ]]}},
    rust       = { cmd = {[[rustc "$file" ; ./"$exename" ; $delete "$exename" ]]}},
    sh         = { cmd = {[[bash "$file" ]]}},
    typescript = { cmd = {[[node --trace-warnings "$file" ]]}},
    lua        = { cmd = {[[luajit "$file" ]]}},
    markdown   = { cmd = {[[glow "$file" ]]}},
    zig        = { cmd = {[[zig run "$file" ]]}},
    ocaml      = { cmd = {[[dune build; dune exec "$proj"]], [[ocaml "$file"]]}}
}
