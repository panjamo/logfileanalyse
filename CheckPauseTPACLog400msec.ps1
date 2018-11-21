
$line1 = ""
$line2 = ""
$lastLine = ""
$lastTime = [datetime]0
$maxDiff = [datetime]0 - [datetime]0

foreach ($line in [System.IO.File]::ReadLines("c:\temp\YellowStoneTestInstallation\Logfiles\LastSave.log")) {
    
    Try {
        $date = [regex]::match($line, '([^I]+) Id.*').Groups[1].Value
        $newTime = [datetime]::ParseExact($date, "dd.MM.yyyy HH:mm:ss:fff", [Globalization.CultureInfo]::CreateSpecificCulture('de-DE'))
    }
    Catch {
        # Write-Host No time found: $_
        continue
    }

    if ($lastTime -eq [datetime]0) {
        $lastTime = $newTime
        $lastLine = $line
    }
    else {
        $diff = $newTime - $lastTime

        if ($diff -gt [TimeSpan]::FromMilliseconds(400)) {
            Write-Host ("{0:G}" -f $diff)
            Write-Host $lastLine
            Write-Host $line    
        }

        if ($diff -gt $maxDiff) {
            $maxDiff = $diff;
            $line1 = $lastLine
            $line2 = $line
        }

        $lastTime = $newTime
        $lastLine = $line
    }
}

Write-Host Maximum:
Write-Host ("{0:G}" -f $maxDiff)
Write-Host $line1
Write-Host $line2


