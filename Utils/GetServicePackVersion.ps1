$ps1Name = "GetServicePackVersion"
$help = @"
$ps1Name
   Retrieve the OS Service Pack Version.

   $ps1Name
"@
if ($ARGS[0] -eq "-h") { $help; break }

# Create a New Excel Object for storing Data
$excelObj = New-Object -comobject Excel.Application
$excelObj.visible = $True 
$workbook1 = $excelObj.Workbooks.Add()
$worksheet1 = $workbook1.Worksheets.Item(1)

# Create the title row
$worksheet1.Cells.Item(1,1) = "Machine Name"
$worksheet1.Cells.Item(1,2) = "OS"
$worksheet1.Cells.Item(1,3) = "Description"
$worksheet1.Cells.Item(1,4) = "Service Pack"

$d = $worksheet1.UsedRange
$d.Interior.ColorIndex = 23
$d.Font.ColorIndex = 2
$d.Font.Bold = $True
$d.EntireColumn.AutoFit($True)

$intRow = 2

$computerName = "."
$worksheet1.Cells.Item($intRow, 1) = $computerName.ToUpper()

# Get Operating System Info
$colOS =Get-WmiObject -class Win32_OperatingSystem -computername $computerName
foreach($objComp in $colOS) {
  $worksheet1.Cells.Item($intRow, 2) = $objComp.Caption
  $worksheet1.Cells.Item($intRow, 3) = $objComp.Description
  $worksheet1.Cells.Item($intRow, 4) = $objComp.ServicePackMajorVersion
}

# Save workbook data
$workbook1.SaveAs("C:\tmp\Checklist.xlsx")

# Quit Excel (Remove "#" if you want to quit Excel after the script is completed)