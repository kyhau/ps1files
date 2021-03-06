$ps1Name = "nm2m"
$help = @"
$ps1Name
    Convert nautical miles to meters.
    1 nautical mile = 1852 meters.

    $ps1Name <NM1> [NM2 ... NMn]
"@
if ($ARGS[0] -eq "-h") { $help; break }

$a = $ARGS.length
if ($a -eq 0) { Write-Warning "Missing <NM value>."; break}

foreach ($value in $ARGS)
{
  [decimal]$nm = $value
  $nm * 1852.0
}
