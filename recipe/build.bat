@echo on

:: Upstream only provides an autoconf/Makefile build, so compile the sources
:: directly with MSVC, mirroring the targets in nn/makefile.in.
:: nn/config.h.in contains no autoconf substitutions and already handles _WIN32.
cd nn
copy config.h.in config.h
if errorlevel 1 exit 1

set LIBSRC=delaunay.c hash.c istack.c lpi.c minell.c nnai.c nnpi.c nncommon.c nncommon-vulnerable.c preader.c

cl /nologo /c /O2 /I. /DTRILIBRARY /DANSI_DECLARATORS triangle.c
if errorlevel 1 exit 1
cl /nologo /c /O2 /I. %LIBSRC%
if errorlevel 1 exit 1
lib /nologo /out:nn.lib *.obj
if errorlevel 1 exit 1

cl /nologo /O2 /I. /DNN_SERIAL nnbathy.c nn.lib /Fe:nnbathy.exe
if errorlevel 1 exit 1
cl /nologo /O2 /I. /DME_STANDALONE minell.c /Fe:minell.exe
if errorlevel 1 exit 1

copy nn.lib %LIBRARY_LIB%\
if errorlevel 1 exit 1
copy nn.h %LIBRARY_INC%\
if errorlevel 1 exit 1
copy nnbathy.exe %LIBRARY_BIN%\
if errorlevel 1 exit 1
copy minell.exe %LIBRARY_BIN%\
if errorlevel 1 exit 1
