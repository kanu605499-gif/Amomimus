Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("d:\Amomimus\Amomimus\assets\icon\icon.png")
Write-Output "PixelFormat: $($img.PixelFormat)"
$img.Dispose()
