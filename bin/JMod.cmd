@echo off

set lvl=%1

if "%1" == "9" ( 
	set lvl=1.%1
    )
if "%1" == "" (
	set lvl=1.9
    )

rem You will have to extract lib/jin/jin(9|11).jar to classes/jar first

.\J9Mod " jar=jin%1.jar level=%lvl%"  
