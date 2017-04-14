$content = (ls songs | ForEach-Object {echo "\input{songs/$($_.Name)}"})
[IO.File]::WriteAllLines('songs.tex', $content)
