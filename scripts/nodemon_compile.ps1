 param (
    [string]$main = $( Read-Host "Main file" )
 )

$name = (split-path $main -Leaf).Split('.')[0]
nodemon --ext "tex" --exec pdflatex "-output-directory" "output/$name" "compilations/$name.tex"
