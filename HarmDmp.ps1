param
(
    [Parameter(Position=0)]
    [string]$name=$null,
    [Parameter(Mandatory=$false)]
    [switch]$raw,
    [Parameter(Mandatory=$false)]
    [switch]$all
)

if($name.Length -eq 36)
{
    if($raw)
    {
        $ret = (adb shell run-as TestHarmAndoird.TestHarmAndoird cat /data/data/TestHarmAndoird.TestHarmAndoird/files/.config/$name.json)
    }
    else 
    {
        $ret = (adb shell run-as TestHarmAndoird.TestHarmAndoird cat /data/data/TestHarmAndoird.TestHarmAndoird/files/.config/$name.json | ConvertFrom-Json)
    }
}
else 
{
    $l=(adb shell run-as TestHarmAndoird.TestHarmAndoird ls /data/data/TestHarmAndoird.TestHarmAndoird/files/.config)
    foreach($f in $l)
    {
        if($f.Length -eq 41)
        {
            $i = (adb shell run-as TestHarmAndoird.TestHarmAndoird cat /data/data/TestHarmAndoird.TestHarmAndoird/files/.config/$f | ConvertFrom-Json)
            if($i.SongInfo.Name -eq $name)
            {
                $ret = $i
                # if($all)
                # {
                #     echo "$($i.SongInfo.Name) v$($i.SongInfo.Version) lc=$($i.Lyrics.Count) lrc=$($i.LyricRefs.Count)"
                #     echo $f
                #     return $i | Format-List
                # }
                # else 
                # {
                #     return $i
                # }
            }
        }
    }
}

if($all -and $raw -ne $true)
{
    echo "$($i.SongInfo.Name) v$($i.SongInfo.Version) lc=$($i.Lyrics.Count) lrc=$($i.LyricRefs.Count)"
    echo $f
    return $i | Format-List
}
else
{
    return $ret
}