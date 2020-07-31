$contents = @"
cd c:\tools\selenium\
java -Dwebdriver.edge.driver="C:\Windows\System32\MicrosoftWebDriver.exe" -jar selenium-server-standalone.jar -log selenium.log
"@

$contents | Out-File -Encoding ASCII "C:\Users\IEUser\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\selenium-startup.cmd"