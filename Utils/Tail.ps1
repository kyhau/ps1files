$ps1Name = "Tail"
$help = @"
$ps1Name
   Unix-like Tail.

   $ps1Name <file name> [number of lines]
"@
if ($ARGS[0] -eq "-h") { $help; break }
if ($ARGS.length -eq 0) { break }

$fileStr = $ARGS[0]
$numOfLines = 10

if ($ARGS.length -eq 2) { $numOfLines = $ARGS[1] }

cat $fileStr | Select-Object -last $numOfLines