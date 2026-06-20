Add-Type -AssemblyName System.Drawing
$width = 400
$height = 800
$bmp = New-Object System.Drawing.Bitmap $width, $height
$rand = New-Object System.Random

# We do this in a single array to speed up SetPixel which is very slow
$rect = New-Object System.Drawing.Rectangle(0, 0, $width, $height)
$bmpData = $bmp.LockBits($rect, [System.Drawing.Imaging.ImageLockMode]::WriteOnly, $bmp.PixelFormat)
$ptr = $bmpData.Scan0
$bytes = [Math]::Abs($bmpData.Stride) * $height
$rgbValues = New-Object byte[] $bytes

for ($i = 0; $i -lt $bytes; $i += 4) {
    $val = [byte]$rand.Next(10, 40)
    $rgbValues[$i] = $val     # B
    $rgbValues[$i+1] = $val   # G
    $rgbValues[$i+2] = $val   # R
    $rgbValues[$i+3] = 255    # A
}

[System.Runtime.InteropServices.Marshal]::Copy($rgbValues, 0, $ptr, $bytes)
$bmp.UnlockBits($bmpData)

$dir = 'android\app\src\main\res\drawable'
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
$bmp.Save("$dir\static_noise.png", [System.Drawing.Imaging.ImageFormat]::Png)
Write-Output "static_noise.png created"
