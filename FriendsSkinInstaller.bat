@echo off

title Steam Friends Skin Installer

echo Welcome to the Steam Friends Skin Installer.
echo Originally Made by Shiina.
echo Adapted by LaserFlash
echo Version 1.0
echo.
echo This tool helps you to install the new Friends Skin for Steam!
echo If you have any questions, Leave a message on our Discord: https://discord.gg/UZvkvkh
echo.
echo.
echo -------------------------------------------------------------
echo                        Prerequisite
echo -------------------------------------------------------------
echo.
echo SteamFriendsPatcher: https://github.com/PhantomGamers/SteamFriendsPatcher/releases
echo This ensures your Steam Friends are always patched to show 
echo the custom theme.
echo.
echo -------------------------------------------------------------
echo.
echo.

echo Checking for Steam directory...
for /f "tokens=1,2*" %%E in ('reg query HKEY_CURRENT_USER\Software\Valve\Steam\') do if %%E==SteamPath set SteamPath=%%G

if exist "%SteamPath%" (echo Steam directory found! && echo.) else (echo Steam directory not found. && echo Confirm Steam is installed and try running this file as administrator. && pause && goto:eof)
echo.

:start
echo Choose an option:
echo 1. Install theme from already downloaded file.
echo 2. Create friends.custom.css from clipboard.
echo 3. Download LaserFlash's default theme.
echo 4. Copy friends.custom.css to Steam Directory.
echo 5. Open friends.custom.css for customisation
echo 6. Exit
echo.
set /p choice= Your choice: 
if %choice%==1 call:copy
if %choice%==2 call:clipboardCreation
if %choice%==3 call:download
if %choice%==4 call:copy
if %choice%==5 call:edit
if %choice%==6 goto:eof
if %choice% gtr 6 ( echo Invalid selection, please try again. && goto:start )
if %choice% leq 0 ( echo Invalid selection, please try again. && goto:start )

:clipboardCreation
    set /p cssImports= Paste friends.custom.css here: 
    echo writing to file
    echo %cssImports% > friends.custom.css
    goto:done

:download
    echo.
    echo Dowloading Files to current folder... 
    powershell -Command "Try{[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LaserFlash/steam-chat-skin/master/src/friends.custom.css', 'friends.custom.css')}Catch{Write-Warning $($error[0]);pause}"
    echo all files have been downloaded succesfully.
    echo.
    goto:done

:copy
    echo.
    if not exist friends.custom.css ( echo  friends.custom.css not found, make sure it's in the same directory as this installer. && echo. && goto:start )

    echo Checking for Steam directory...
    for /f "tokens=1,2*" %%E in ('reg query HKEY_CURRENT_USER\Software\Valve\Steam\') do (
        if %%E==SteamPath set SteamPath=%%G
        if %%E==FriendsSkin set FriendsSkin=%%G

    )

    if exist "%SteamPath%" (echo Steam directory found! && echo.) else (echo Steam directory not found. && echo Confirm Steam is installed and try running this file as administrator. && pause && goto:eof)

    if [%FriendsSkin%]==[] echo No Friends Skin found... && set FriendsPath=%SteamPath%/clientui/friends.custom.css
    if not [%FriendsSkin%]==[] set FriendsPath=%SteamPath%/clientui/friends.custom.css

    echo Checking for write access to Steam directory...

    mkdir "%SteamPath%/tmp"
    if exist "%SteamPath%/tmp" (rmdir "%SteamPath%/tmp" && echo Success! && echo.) else (echo Write access denied, try running this file as administrator. && pause && goto:eof)

    echo Copying Steam Friends Skin to Steam directory...
        copy /Y friends.custom.css "%FriendsPath%"
    )
    if not [%FriendsSkin%]==[] copy /Y friends.custom.css "%FriendsPath%" >nul
    echo.
    goto:done

:edit
    if not exist friends.custom.css (echo  friends.custom.css not found, Downloading default now. && echo. && call:download)
    echo Opening default text editor
    start "" friends.custom.css
    goto:done

:done   
    echo Operation completed
    echo If you want to perform another task please select one 
    goto:start