param (
    [Parameter(Mandatory=$true)][string[]]$Paths
)

Add-Type -AssemblyName System.Drawing

$source = @"
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;

public class StickerPipeline {
    public static void Process(string[] paths, int strokeWidth) {
        foreach (var path in paths) {
            Bitmap bmp1 = new Bitmap(path);
            Bitmap bmp2 = new Bitmap(bmp1.Width, bmp1.Height, PixelFormat.Format32bppArgb);
            using (Graphics g = Graphics.FromImage(bmp2)) { g.DrawImage(bmp1, 0, 0); }
            bmp1.Dispose();
            
            Rectangle rect2 = new Rectangle(0, 0, bmp2.Width, bmp2.Height);
            BitmapData data2 = bmp2.LockBits(rect2, ImageLockMode.ReadWrite, bmp2.PixelFormat);
            int bytes2 = Math.Abs(data2.Stride) * bmp2.Height;
            byte[] rgb2 = new byte[bytes2];
            Marshal.Copy(data2.Scan0, rgb2, 0, bytes2);
            for (int i = 0; i < rgb2.Length; i += 4) {
                if (rgb2[i+2] > 200 && rgb2[i+1] > 200 && rgb2[i] > 200) rgb2[i+3] = 0;
            }
            Marshal.Copy(rgb2, 0, data2.Scan0, bytes2);
            bmp2.UnlockBits(data2);
            
            int minX = bmp2.Width, minY = bmp2.Height, maxX = 0, maxY = 0;
            for (int y = 0; y < bmp2.Height; y++) {
                for (int x = 0; x < bmp2.Width; x++) {
                    Color c = bmp2.GetPixel(x, y);
                    if (c.A > 10) {
                        if (x < minX) minX = x;
                        if (x > maxX) maxX = x;
                        if (y < minY) minY = y;
                        if (y > maxY) maxY = y;
                    }
                }
            }
            int pad = 10;
            minX = Math.Max(0, minX - pad);
            minY = Math.Max(0, minY - pad);
            maxX = Math.Min(bmp2.Width - 1, maxX + pad);
            maxY = Math.Min(bmp2.Height - 1, maxY + pad);
            Rectangle cropRect = new Rectangle(minX, minY, maxX - minX + 1, maxY - minY + 1);
            if (cropRect.Width <= 0 || cropRect.Height <= 0) { bmp2.Dispose(); continue; }
            Bitmap bmp3 = bmp2.Clone(cropRect, bmp2.PixelFormat);
            bmp2.Dispose();
            
            int nw = bmp3.Width + strokeWidth * 2;
            int nh = bmp3.Height + strokeWidth * 2;
            Bitmap bmp4 = new Bitmap(nw, nh, PixelFormat.Format32bppArgb);
            
            Rectangle srcR = new Rectangle(0, 0, bmp3.Width, bmp3.Height);
            BitmapData srcD = bmp3.LockBits(srcR, ImageLockMode.ReadOnly, bmp3.PixelFormat);
            Rectangle dstR = new Rectangle(0, 0, nw, nh);
            BitmapData dstD = bmp4.LockBits(dstR, ImageLockMode.WriteOnly, bmp4.PixelFormat);
            
            int sBytes = Math.Abs(srcD.Stride) * bmp3.Height;
            byte[] sVals = new byte[sBytes];
            Marshal.Copy(srcD.Scan0, sVals, 0, sBytes);
            
            int dBytes = Math.Abs(dstD.Stride) * nh;
            byte[] dVals = new byte[dBytes];
            
            int sBpp = Image.GetPixelFormatSize(bmp3.PixelFormat) / 8;
            int sStride = srcD.Stride;
            int dStride = dstD.Stride;
            
            for (int y = 0; y < nh; y++) {
                for (int x = 0; x < nw; x++) {
                    int dIdx = y * dStride + x * 4;
                    int sX = x - strokeWidth;
                    int sY = y - strokeWidth;
                    
                    bool inSrc = sX >= 0 && sX < bmp3.Width && sY >= 0 && sY < bmp3.Height;
                    bool isOpq = false;
                    
                    if (inSrc) {
                        int sIdx = sY * sStride + sX * sBpp;
                        if (sVals[sIdx + 3] > 80) {
                            isOpq = true;
                            dVals[dIdx] = sVals[sIdx];
                            dVals[dIdx+1] = sVals[sIdx+1];
                            dVals[dIdx+2] = sVals[sIdx+2];
                            dVals[dIdx+3] = sVals[sIdx+3];
                        }
                    }
                    
                    if (!isOpq) {
                        bool near = false;
                        for (int dy = -strokeWidth; dy <= strokeWidth; dy++) {
                            for (int dx = -strokeWidth; dx <= strokeWidth; dx++) {
                                if (dx*dx + dy*dy <= strokeWidth*strokeWidth) {
                                    int cX = sX + dx;
                                    int cY = sY + dy;
                                    if (cX >= 0 && cX < bmp3.Width && cY >= 0 && cY < bmp3.Height) {
                                        int cIdx = cY * sStride + cX * sBpp;
                                        if (sVals[cIdx + 3] > 80) {
                                            near = true;
                                            break;
                                        }
                                    }
                                }
                            }
                            if (near) break;
                        }
                        if (near) {
                            dVals[dIdx] = 255; dVals[dIdx+1] = 255; dVals[dIdx+2] = 255; dVals[dIdx+3] = 255;
                        }
                    }
                }
            }
            
            Marshal.Copy(dVals, 0, dstD.Scan0, dBytes);
            bmp3.UnlockBits(srcD);
            bmp4.UnlockBits(dstD);
            bmp3.Dispose();
            
            bmp4.Save(path + ".final.png", ImageFormat.Png);
            bmp4.Dispose();
        }
    }
}
"@

Add-Type -TypeDefinition $source -ReferencedAssemblies System.Drawing
[StickerPipeline]::Process($Paths, 3)

foreach ($path in $Paths) {
    Remove-Item $path -Force
    Rename-Item "$path.final.png" $path
}
Write-Host "Processed "($Paths.Count)" stickers successfully!"
