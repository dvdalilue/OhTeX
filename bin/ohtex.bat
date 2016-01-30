@echo off
title ohtex
echo OhTeX [Version 0.1]

if "%1" == "" goto noargs

if exist %1 (
	rem file exist!
	ruby %1 > "%~dpn1".tex
	rem echo "%~dpn1".tex
	start /wait %~p0miktex\miktex\bin\pdflatex "%~dpn1".tex
	::echo "%~dp0"miktex\bin\pdflatex.exe
	del %cd%\"%~n1".out
	del %cd%\"%~n1".aux
	del %cd%\"%~n1".log
	del "%~dpn1".tex
) else (
	echo file dosen't exist!
	goto finish
)

goto done

:done

echo Compilation finished!
goto finish

:noargs

echo Missing parameter!

:finish

pause >nul