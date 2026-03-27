$content = [System.IO.File]::ReadAllText((Join-Path $PWD "index.html"), [System.Text.Encoding]::UTF8)
$content = $content -replace [char]0x2014, [char]0x2014  # already correct
# Find and replace the broken em-dash string
$broken = "'" + [char]0xE2 + [char]0x80 + [char]0x94 + "'"
$correct = "'" + [char]0x2014 + "'"
Write-Host "Looking for broken: $broken"
if ($content.Contains($broken)) {
    $content = $content.Replace($broken, $correct)
    [System.IO.File]::WriteAllText((Join-Path $PWD "index.html"), $content, [System.Text.Encoding]::UTF8)
    Write-Host "Fixed em-dash"
} else {
    Write-Host "No broken em-dash found"
}
