copy "*Bank Check*" "$env:USERPROFILE\Desktop" 
.\drawrectangle.ps1 -imgpath "$env:USERPROFILE\Desktop\BANK CHECK_JPG.jpg" -newImgPath "$env:USERPROFILE\Desktop\bankCheck_JPG_Redcated.jpg" -Height 40 -Width 550 -x 100 -y 350
pause
#since the compression is not correct for this image it should change the picture to black and white redacted.
.\drawrectangle.ps1 -imgpath "$env:USERPROFILE\Desktop\BANK CHECK_TIF2.tif" -newImgPath "$env:USERPROFILE\Desktop\BANKCHECK_TIF2_Redcated.tif" -Height 40 -Width 550 -x 100 -y 350
pause
.\drawrectangle.ps1 -imgpath "$env:USERPROFILE\Desktop\BANK CHECK_bmp.bmp" -newImgPath "$env:USERPROFILE\Desktop\BANKCHECK_bmp_Redacted.bmp" -Height 40 -Width 550 -x 100 -y 350

Pause
#this one should error as it  is outside the bounds of our image
.\drawrectangle.ps1  -imgpath "$env:USERPROFILE\Desktop\BANK CHECK_JPG.jpg" -newImgPath "$env:USERPROFILE\Desktop\bankCheck_JPG_RedcatedHeightToBig.jpg" -Height 40 -Width 550 -x 10000 -y 350