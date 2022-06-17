

$templogfile = ".\templog.log"

$notdone = $true

while($notdone)
{
    adb logcat -t ((Get-Date).AddMinutes(-5).ToString("MM-dd HH:ss:mm.ffff")) > $templogfile
    if((dir $templogfile).Length -gt 0)
    {
        $notdone = $false
    }

    # Start-Sleep -s 1
}

if($notdone -eq $false)
{
    &"E:\Users\Paul\Downloads\TextAnalysisTool.NET\Latest Without Plug-in Support\TextAnalysisTool.NET.exe" $templogfile /Filters:$args
}
else 
{
    Write-Output "log blank"    
}