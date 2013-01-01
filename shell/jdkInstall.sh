#!/usr/bin/expect
m remote
softDir=/home/soft
#downURL=http://download.oracle.com/otn-pub/java/jdk/6u38-b05/jdk-6u38-linux-x64
.bin?AuthParam=1357051857_a13bef3c6bfefd744d44f294648956b5
if [ ! -d $softDir ]; then
       mkdir $softDir
fi
#cd $softDir
#wget -c $downURL

#install
installDir=/home/p
if [ ! -d $installDir ]; then
        mkdir $installDir
fi

cd $installDir

jdkBinFileName=jdk-6u38-linux-x64.bin
jdkFileWithPath=$installDir/$jdkBinFileName
if [ ! -f $jdkFileWithPath ];then
        cp $softDir/$jdkBinFileName $installDir
fi
chmod +x $jdkFileWithPath

expect << eof
        set timeout 10
        spawn sh $jdkFileWithPath
        expect "Press Enter to continue....."
        send "\n"
eof

echo "seting /etc/profile ... "

etcProfile=/etc/profile
echo 'JAVA_HOME=/home/p/jdk1.6.0_38' >> $etcProfile
echo 'PATH=$PATH:$JAVA_HOME/bin' >> $etcProfile
echo 'CLASSPATH=.:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar' >> $etcProfile
echo 'export JAVA_HOME PATH CLASSPATH' >> $etcProfile
source $etcProfile

echo 'reboot to efforce'

#down from remote
softDir=/home/soft
#downURL=http://download.oracle.com/otn-pub/java/jdk/6u38-b05/jdk-6u38-linux-x64
.bin?AuthParam=1357051857_a13bef3c6bfefd744d44f294648956b5
if [ ! -d $softDir ]; then
       mkdir $softDir
fi
#cd $softDir
#wget -c $downURL

#install
installDir=/home/p
if [ ! -d $installDir ]; then
        mkdir $installDir
fi

cd $installDir

jdkBinFileName=jdk-6u38-linux-x64.bin
jdkFileWithPath=$installDir/$jdkBinFileName
if [ ! -f $jdkFileWithPath ];then
        cp $softDir/$jdkBinFileName $installDir
fi
chmod +x $jdkFileWithPath

expect << eof	
	set timeout 10
	spawn sh $jdkFileWithPath
	expect "Press Enter to continue....."
	send "\n"
eof

echo "seting /etc/profile ... "

etcProfile=/etc/profile
echo 'JAVA_HOME=/home/p/jdk1.6.0_38' >> $etcProfile
echo 'PATH=$PATH:$JAVA_HOME/bin' >> $etcProfile
echo 'CLASSPATH=.:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar' >> $etcProfile
echo 'export JAVA_HOME PATH CLASSPATH' >> $etcProfile
source $etcProfile

echo "finished ! jdk installed to $installDir"
