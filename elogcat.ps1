$templogfile = ".\templog.log"

$notdone = $true

$filter=$args[0]

if($args[1] -ne $null)
{
    $tid = "-t " + $args[1]
}

while($notdone)
{
    if($args[1] -ne $null)
    {
        adb -t $args[1] logcat -t ((Get-Date).AddMinutes(-5).ToString("MM-dd HH:ss:mm.ffff")) > $templogfile
    }
    else
    {
        adb logcat -t ((Get-Date).AddMinutes(-5).ToString("MM-dd HH:ss:mm.ffff")) > $templogfile
    }

    if((dir $templogfile).Length -gt 0)
    {
        $notdone = $false
    }

    # Start-Sleep -s 1
}

if($notdone -eq $false)
{
    &"E:\Users\Paul\Downloads\TextAnalysisTool.NET\Latest Without Plug-in Support\TextAnalysisTool.NET.exe" $templogfile /Filters:$filter
}
else 
{
    Write-Output "log blank"    
}