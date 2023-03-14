REM Adjust %WINCUPL_DIR% to point to your WinCUPL installation
SET WINCUPL_DIR=C:\WinCUPL

SET LIBCUPL=%WINCUPL_DIR%\Shared\Atmel.dl

%WINCUPL_DIR%\Shared\cupl.exe -m1lxfjnabe MultiROM-U2.pld
