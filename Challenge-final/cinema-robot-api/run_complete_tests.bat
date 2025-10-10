@echo off
echo ========================================
echo Cinema API Robot Framework Test Suite
echo ========================================
echo.

echo Checking if API is running...
curl -s http://localhost:3000/api/v1/ > nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: API is not running on http://localhost:3000
    echo Please start the API first:
    echo   cd Challenge-final/cinema-challenge-back
    echo   npm run dev
    echo.
    pause
    exit /b 1
)

echo API is running! Starting tests...
echo.

echo ========================================
echo Running Auth Tests
echo ========================================
robot -d logs/auth -i auth tests/auth_tests.robot

echo.
echo ========================================
echo Running Movie Tests  
echo ========================================
robot -d logs/movies tests/movie_tests.robot

echo.
echo ========================================
echo Running Integration Tests
echo ========================================
robot -d logs/integration tests/api_integration_tests.robot

echo.
echo ========================================
echo Test Summary
echo ========================================
echo Check the following directories for detailed results:
echo - logs/auth/
echo - logs/movies/  
echo - logs/integration/
echo.
echo Open report.html files in your browser to see detailed results.
echo.
pause