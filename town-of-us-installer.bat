@echo off
setlocal enableDelayedExpansion
set "steamPath="
for /f "tokens=2,*" %%A in ('reg query "HKLM\SOFTWARE\Wow6432Node\Valve\Steam" /v InstallPath 2^>nul') do set "steamPath=%%B"
set "gameDir=!steamPath!\steamapps\common\TOU"
set "manifest="
set "version="
set "scriptVersion=3"
set "updateVersion="
for /f "tokens=1,* delims=: " %%A in ('curl -s "https://raw.githubusercontent.com/Fl4keyJakey/Install-For-Town-Of-Us/refs/heads/main/manifest-and-mod-version.txt"') do (
    if /i "%%A"=="Manifest" set "manifest=%%B"
    if /i "%%A"=="Version" set "version=%%B"
    if /i "%%A"=="ScriptVersion" set "updateVersion=%%B"
)


:choice
cls
echo Town Of Us Installer [Made by _J011y_ on discord]
echo.
echo 1. Install DepotDownloader (Needed for the script to work)
echo 2. Install Among Us With Town Of Us
echo 3. Uninstall DepotDownloader (Won't break Among Us)
echo 4. Check For Updates (Work In Progress)
echo 5. Exit
echo.

choice /c 12345 /m "what do you want to do:"

if errorlevel 5 goto exit
if errorlevel 4 goto checkforupdates
if errorlevel 3 goto uninstall
if errorlevel 2 goto amonginstall
if errorlevel 1 goto installsetup


:installsetup
cls
winget install --exact --id SteamRE.DepotDownloader
goto choice


:amonginstall
cls
echo shutting down steam...
taskkill /f /im "steam.exe" >NUL 2>&1
timeout /T 5 /nobreak
cls
echo a qr code will popup, use your steam app to login to be able to download the version of among us needed.
echo don't worry, it won't save your login
pause
depotDownloader -qr -app 945360 -depot 945361 -manifest %manifest% -dir "%gameDir%"
curl -L -o "%gameDir%\TOU.zip" https://github.com/eDonnes124/Town-Of-Us-R/releases/download/%version%/ToU.%version%.zip
tar -xf "%gameDir%\TOU.zip" -C "%gameDir%"
robocopy "%gameDir%\ToU %version%" "%gameDir%" /E
del "%gameDir%\TOU.zip"
rmdir /S /Q "%gameDir%\ToU %version%"
cls
echo Steam will now open...
cd /d "%steamPath%"
start .\steam.exe
timeout /T 5 /nobreak
cls
echo now you have to add the game as a non-steam game.
echo.
echo to do so press on the plus in the bottom left where it says "Add a game".
echo.
echo then click "Add a Non-Steam Game...".
echo.
echo then click "Browse..." in the bottom left.
echo.
echo then go to !gameDir! (you can copy and paste if you want), and add "Among Us.exe".
echo.
echo then click "Add Selected Programs".
pause
cls
echo now everything should work, you can open the game like any other steam game.
pause
goto choice


:uninstall
cls
winget uninstall SteamRE.DepotDownloader
goto choice


:checkforupdates
cls
if "%scriptVersion%"=="%updateVersion%" (
    echo You have the latest version!
    pause
    goto choice
) else if "%scriptVersion%"=="" (
    echo Couldn't Get New Version Number!
    pause
    goto choice
) else if not "%scriptVersion%"=="%updateVersion%" (
    echo Update found! Press any key to update
    pause
    cls
    curl -L -o "%~dp0%~nx0.new" https://raw.githubusercontent.com/Fl4keyJakey/Install-For-Town-Of-Us/refs/heads/main/town-of-us-installer.bat
    if exist "%~dp0%~nx0.new" (
       start /b "" cmd /c del /F /Q "%~dp0%~nx0" && timeout /T 2 /nobreak && rename "%~dp0%~nx0.new" "%~nx0" && start .\%~nx0 && exit /b
    ) else (
        cls
        echo Error update not downloaded
    )
)


:exit