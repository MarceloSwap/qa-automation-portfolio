@echo off
echo Testing Cinema API Robot Framework fixes...
echo.

echo Running auth tests only...
robot -d logs/ -i auth tests/auth_tests.robot

echo.
echo Test completed. Check logs/ directory for results.
pause