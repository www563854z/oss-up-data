#-------------------------------------------------------------------------------------------------------------
# Exp:       对象存储上传脚本-基于qshell工具
# Author:    YuanHai
# Modify:    YuanHai
# Date:      2023/02/20
# Version:   2023.02.v2
# 更新内容： 2023.02.v1 添加压缩
# Other： qshell下载地址：https://developer.qiniu.com/kodo/1302/qshell
#-------------------------------------------------------------------------------------------------------------

#qshell主程序,记住需要设置这个文件路径相应的变量环境
$qshellPath = "D:\Everyday_Backup\qshell\qshell.exe"

#对象存储参数
$OssName = "test" #qshell中保存的名字
$AccesssKey = "AccesssKey"  #AK
$SecretKey = "SecretKey"  #SK
$BucketName = "Bucket" #对象存储中的Bucket名字

#备份文件目录
$DataPath = "D:\Everyday_Backup\DATA"

#获取备份目录最新一次文件路径
$Last  = Get-ChildItem $DataPath | Sort-Object lastwritetime -Descending
$LastFile = $Last.Name[0]
$UpDataFile = "$DataPath\$LastFile"

#压缩功能
$ZipPath = "D:\Everyday_Backup\ZIP" #压缩存放路径
$ZipName = "$LastFile.zip"
$Zipfile = "$ZipPath\$ZipName"
Compress-Archive  -LiteralPath "$UpDataFile" -CompressionLevel "Optimal" -DestinationPath "$Zipfile" -Force

#建立OSS链接用户和授权
qshell user clean
qshell user add --ak $AccesssKey --sk $SecretKey --name $OssName
qshell user cu $OssName

#执行上传文件
qshell fput $BucketName $ZipName $Zipfile --storage 1 --overwrite >> D:\Everyday_Backup\Log\UpLog.txt

#清理授权信息
qshell user remove $OssName