@echo off
rem Double-click this file to sort the manuals. The window stays open so you can read the result or any error.
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -NoExit -File "%~dp0setup-docs.ps1"
