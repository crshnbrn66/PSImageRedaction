param($imgpath = "~\desktop\BANK CHECK_TIF.tif", $newImgPath = "~\desktop\BANK CHECK_TIF2.tif", $RectHeight = 40, $rectWidth = 550, $rectX = 100 , $recty =350)
#todo must find a means to test path if image is not there
$newImgPath = (gi $newImgPath).FullName
$imgpath = (gi $imgpath).fullname
function Get-Encoding([string]$filename)
{
    #https://stackoverflow.com/questions/3825390/effective-way-to-find-any-files-encoding
    #$bom = [System.Byte[]]::new(4)
    $sr = [System.IO.StreamReader]::new($filename)
    $sr.peek |Out-Null
    $currentEncoding = $sr.CurrentEncoding
    $sr.Dispose()
    $currentEncoding
}
function Get-ImageDimensionResolution
{ #https://stackoverflow.com/questions/4048185/read-a-tiff-files-dimension-and-resolution-without-loading-it-first
    param([string]$filename)
    $fs = [System.IO.FileStream]::new($filename, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read)
    $img = [System.Drawing.Image]::FromStream($fs,$false,$false)

    $Image = [PSCustomObject]@{
        filename = $filename
        width  =$img.PhysicalDimension.Width
        height = $img.PhysicalDimension.Height
        HorizontalResolution = $img.HorizontalResolution
        VerticalResolution = $img.VerticalResolution

    }
    $img.Dispose()
    $fs.Dispose()
    $Image
}
function Get-ImageType
{
    param($filename)
    try {
        $Img = [System.Drawing.Image]::FromFile($filename)
        $t = [System.Drawing.Imaging.ImageFormat]   
        $types =($t.GetMethods().name | Where-Object{$_ -like "get_*"}).replace("get_",'')
        foreach($type in $types){if($Img.RawFormat.Guid.Guid -eq $t::$type.Guid.Guid){$value = $type}}
        $Img.Dispose()
    }
    catch {
        $value = "$filename is not an image"
    }
    $value
}
#------- Set encoding value for Tif images --------------------
$myEncoder = [System.Drawing.Imaging.Encoder]::Compression

$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1) 
$encparm = New-Object System.Drawing.Imaging.EncoderParameter($myEncoder,4)
$encoderParams.Param[0] = $encparm 
$imagetype = Get-ImageType $imgpath
#set the codec info to the same type as the file in
$myImageCodecInfo = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders()|Where-Object {$_.FormatDescription -eq "$imagetype"}

#--------Read file and creat new canvas---------------------
$org = [System.Drawing.Bitmap]::FromFile($ImgPath);
$orgSize= Get-ImageDimensionResolution $imgpath
$BM = [System.Drawing.Bitmap]::new($org,$orgSize.width, $orgSize.height)
$BM.SetResolution($org.HorizontalResolution,$org.VerticalResolution)
#$BM.SetResolution(200,200)

#----------Create Drawing method and load Image into it----- 
$g = [System.Drawing.Graphics]::FromImage($bm)
$g.DrawImage($org,0,0, $orgSize.width, $orgSize.height)

#---------- Draw on canvas ---------------------------------
if(($RectHeight -lt $orgSize.height) -or ($rectX -lt $orgSize.height))
{
   
    if(($RectWidth -lt $orgSize.width) -or ($recty -lt $orgSize.width))
    {
       $g.FillRectangle([System.Drawing.Brushes]::White,$rectX,$recty, $rectWidth, $rectHeight)
       #------------- SAVE FILE ------------------------------------
       $bm.Save($newimgpath,$myImageCodecInfo, $encoderParams) 
    }
    else
    {throw 'Redact Width is to large Check Y or width'}
    

}
else
{ throw 'Redact Height is to large Check X or Height'}

#-------------------- Clean up memory -----------------------
if($g){$g.Dispose();}
if($bm){$bm.Dispose()}
if($org){$org.Dispose()}