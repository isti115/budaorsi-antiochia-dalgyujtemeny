Param(
  [string]$path
)

$replacements = @{
  "Á" = "A";
  "É" = "E";
  "Í" = "I";
  "Ó" = "O";
  "Ő" = "Ö";
  "Ú" = "U";
  "Ű" = "Ü"
}

function EqualsWithoutAccents ($a, $b)
{
  $null = $replacements.Keys | ForEach-Object {
    $a = $a -replace $_, $replacements[$_]
    $b = $b -replace $_, $replacements[$_]
  }

  $a -eq $b
}
function LowerFirst ($title)
{
  $title.Substring(0, 1).ToLower() + $title.Substring(1)
}

$originalData = Get-Content -Path "$path" -Encoding "UTF8"
$matchedData = $originalData | Select-String "(\\idx(?:alt)?entry\{((.).*?)\}.*)"
$sortedData = $matchedData | Sort-Object { $_.Matches.Groups[2] }

$previousInitial = "A"
$output = "\begin{idxblock}{A}`n"

$sortedData | ForEach-Object {
  if ( -Not (EqualsWithoutAccents $_.Matches.Groups[3].Value $previousInitial) ) {
    $previousInitial = $_.Matches.Groups[3].Value
    $output += "\end{idxblock}`n`n\begin{idxblock}{$previousInitial}`n"
  }

  $output += ("  $($_.Matches.Groups[1].Value)`n" -replace "\{(.*),~A\}", "{A `$1}")
}

$output += "\end{idxblock}"

$output | Out-File -FilePath ".\$path-fixed" -Encoding "UTF8"
