$ps1Name = "ms2kt"
$help = @"
$ps1Name
    Convert meters per second to knots.
    1 m/s = 3600.0 / 1853.248 kt.

    $ps1Name <MS1> [MS2 ... MSn]
"@
if ($ARGS[0] -eq "-h") { $help; break }

$a = $ARGS.length
if ($a -eq 0) { Write-Warning "Missing <MS value>."; break}

foreach ($value in $ARGS)
{
  [decimal]$ms = $value
  $ms * 3600.0 / 1853.248
}
