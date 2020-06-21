@echo off
setlocal

if not "%1"=="" goto hack

for /F "delims=" %%i in ('dir /s/b %LOCALAPPDATA%\Microsoft\VisualStudio\16.0_*') do (
	echo "%%i"
    call "%~f0" "%%i"
)
goto end

:hack
set vs_instance=%~nx1
set tmp_key=HKLM\_vs_%vs_instance%
set themes_key=%tmp_key%\Software\Microsoft\VisualStudio\%vs_instance%_Config\Themes

reg load %tmp_key% "%~1\privateregistry.bin" > nul
if errorlevel 1 ( 
	echo "error load"
 	goto end 
 )

rem Query GUID Block
if not "%2"=="" (
	for /f "tokens=3 skip=2" %%v in ('reg query %themes_key%\%2 /v Name') do (
		echo %2 %%v
	)
	goto end
)
for /f "tokens=2 delims={}" %%A in ('reg query %themes_key%') do (
	 call %0 %1 {%%A}
)
rem ---------------------------------

reg query %themes_key%\{a5c004b4-2d4b-494e-bf01-45fc492522c7}.backup > nul 2>&1
if errorlevel 1 ( 
	reg copy %themes_key%\{a5c004b4-2d4b-494e-bf01-45fc492522c7} %themes_key%\{a5c004b4-2d4b-494e-bf01-45fc492522c7}.backup /s > nul
	if errorlevel 1 ( 
	 	goto unload 
	 ) 
 ) 
reg copy %themes_key%\{1ded0138-47ce-435e-84ef-9ec1f439b749} %themes_key%\{a5c004b4-2d4b-494e-bf01-45fc492522c7} /s /f > nul
if errorlevel 1 ( 
	echo "error copy
 ) 

:unload
reg unload %tmp_key% > nul
if errorlevel 1 ( 
	echo "error unload"
 	goto end 
 ) 
echo OK
:end
