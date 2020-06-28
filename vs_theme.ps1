Get-ChildItem -Path "$env:LOCALAPPDATA\Microsoft\VisualStudio\16.0_*" -Directory |
ForEach-Object -Process {
    $vs_instance = Split-Path $_.FullName -leaf
    $tmp_key = "HKLM\_vs_$vs_instance"
    $themes_key="$tmp_key\Software\Microsoft\VisualStudio\$vs_instance"+"_Config\Themes"
}

Write-Host "Num Args:" $args.Length;
foreach ($arg in $args) {
    Write-Host "Arg: $arg";
}
