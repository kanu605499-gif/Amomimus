Add-Type -AssemblyName System.Drawing
$inputFile = "d:\Amomimus\Amomimus\assets\icon\icon.png"
$outputFile = "d:\Amomimus\Amomimus\assets\icon\icon_32bit.png"

$img = [System.Drawing.Image]::FromFile($inputFile)
$bmp = New-Object System.Drawing.Bitmap($img.Width, $img.Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$graphics = [System.Drawing.Graphics]::FromImage($bmp)
$graphics.DrawImage($img, 0, 0, $img.Width, $img.Height)

$bmp.Save($outputFile, [System.Drawing.Imaging.ImageFormat]::Png)

$graphics.Dispose()
$bmp.Dispose()
$img.Dispose()
