@echo off

set root=%~dp0
set root=%root:~0,-5%

if "%1%" == "" return

if %1 == J9Mod  if "%WD%" == "" (
    echo "Please set WD(working directory) envirnoment variable to at least .\ "
    echo "After setting WD, see help about the Working Directory - jwin J9Mod " help""
    goto end
  )

set bypassMods=false
set use9=false
set jarFile=jin.jar
if not x"%JAVA_HOME:jdk-9=%"==x"%JAVA_HOME%" ( 
    set use9=true
    set jarFile=jin9.jar
)

if "%JIN_HOME%" == "" (
    set JIN_HOME=%root%
)
if "%JIN_APP%" == "" (
    set JIN_APP=%root%
)
set CD=%JIN_APP%\classes

set LIB=%JIN_HOME%\lib

set cd2=
for /F %%p in ('dir /b %LIB%\*.jar') DO call :append %%p

if (%WD%) NEQ () goto next
set WD=%JIN_APP%\scripts
:next

set jarFile=%LIB%\jin\%jarFile%

FOR  /F "tokens=1* delims===" %%a IN ("%2") DO (
       set bypassMods=%%b
      )

if "%bypassMods%"=="true" ( set use9=false )
if %1==J9Mod ( set use9=false )
if "%use9%"=="true" (
    "%JAVA_HOME%"\bin\java  -cp %jarFile%;%CD%;.;"%JAVA_HOME%"\lib\tools.jar;"%CD2%";"%CLASSPATH%" -p %jarFile% -m jin.it/jin.shell.JinScript sr="%1" cd="%2" "%3" "%4" "%5" wd=%WD% co="-Xlint:-unchecked"
) else (
    "%JAVA_HOME%"\bin\java  -cp %jarFile%;%CD%;.;"%JAVA_HOME%"\lib\tools.jar;"%CD2%";"%CLASSPATH%" jin.shell.JinScript sr="%1" cd="%2" "%3" "%4" "%5" wd=%WD% co="-Xlint:-unchecked"
)
goto end

:append

echo.%1|findstr /C:"jin*.jar" >nul 2>&1
if errorlevel 1 ( 
   set cd2=%cd2%;%LIB%\%1
)

:end
