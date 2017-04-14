 param (
    [string]$main = $( Read-Host "Main file" )
 )

$name = (split-path $main -Leaf).Split('.')[0]
nodemon -e tex --exec pdflatex "-output-directory" "output/$name" "compilations/$name.tex"
