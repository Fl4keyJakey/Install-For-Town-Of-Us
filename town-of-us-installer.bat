@echo off
setlocal enableDelayedExpansion
set "steamPath="
for /f "tokens=2,*" %%A in ('reg query "HKLM\SOFTWARE\Wow6432Node\Valve\Steam" /v InstallPath 2^>nul') do set "steamPath=%%B"
set "gameDir=!steamPath!\steamapps\common\TOU"

:choice
cls
echo Town Of Us Installer [Made by _J011y_ on discord]
echo.
echo 1. Install DepotDownloader (Needed for the script to work)
echo 2. Install Among Us With Town Of Us
echo 3. Uninstall DepotDownloader (Won't break Among Us)
echo 4. Exit
echo.

choice /c 1234 /m "what do you want to do:"

if errorlevel 4 goto exit
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
depotDownloader -qr -app 945360 -depot 945361 -manifest 8040785713895232554 -dir "%gameDir%"
curl -L -o "%gameDir%\TOU.zip" https://github.com/eDonnes124/Town-Of-Us-R/releases/download/v5.3.1/ToU.v5.3.1.zip
tar -xf "%gameDir%\TOU.zip" -C "%gameDir%"
robocopy "%gameDir%\ToU v5.3.1" "%gameDir%" /E
del "%gameDir%\TOU.zip"
rmdir /S /Q "%gameDir%\ToU v5.3.1"
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

:exit