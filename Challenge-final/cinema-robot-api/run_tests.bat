@echo off
echo ========================================
echo Cinema API - Robot Framework Tests
echo ========================================
echo.

REM Verifica se a API está rodando
echo Verificando se a API está rodando...
curl -s http://localhost:3000/api/v1/ > nul
if %errorlevel% neq 0 (
    echo ERRO: API não está rodando em http://localhost:3000
    echo Por favor, inicie a API primeiro:
    echo   cd ../cinema-challenge-back
    echo   npm run dev
    echo.
    pause
    exit /b 1
)

echo ✓ API está rodando
echo.

REM Menu de opções
:menu
echo Escolha uma opção:
echo.
echo 1. Executar todos os testes
echo 2. Testes de Autenticação
echo 3. Testes de Filmes
echo 4. Testes de Usuários (Admin)
echo 5. Testes de Reservas
echo 6. Testes de Integração
echo 7. Testes Positivos apenas
echo 8. Testes Negativos apenas
echo 9. Testes de Admin apenas
echo 0. Sair
echo.

set /p choice="Digite sua escolha (0-9): "

if "%choice%"=="0" goto :end
if "%choice%"=="1" goto :all_tests
if "%choice%"=="2" goto :auth_tests
if "%choice%"=="3" goto :movie_tests
if "%choice%"=="4" goto :user_tests
if "%choice%"=="5" goto :reservation_tests
if "%choice%"=="6" goto :integration_tests
if "%choice%"=="7" goto :positive_tests
if "%choice%"=="8" goto :negative_tests
if "%choice%"=="9" goto :admin_tests

echo Opção inválida!
goto :menu

:all_tests
echo Executando todos os testes...
robot -d ./logs tests/
goto :show_results

:auth_tests
echo Executando testes de autenticação...
robot -d ./logs tests/auth_tests.robot
goto :show_results

:movie_tests
echo Executando testes de filmes...
robot -d ./logs tests/movie_tests.robot
goto :show_results

:user_tests
echo Executando testes de usuários...
robot -d ./logs tests/user_management_tests.robot
goto :show_results

:reservation_tests
echo Executando testes de reservas...
robot -d ./logs tests/reservation_tests.robot
goto :show_results

:integration_tests
echo Executando testes de integração...
robot -d ./logs tests/api_integration_tests.robot
goto :show_results

:positive_tests
echo Executando testes positivos...
robot -d ./logs -i positive tests/
goto :show_results

:negative_tests
echo Executando testes negativos...
robot -d ./logs -i negative tests/
goto :show_results

:admin_tests
echo Executando testes de admin...
robot -d ./logs -i admin tests/
goto :show_results

:show_results
echo.
echo ========================================
echo Execução concluída!
echo ========================================
echo.
echo Relatórios gerados em: ./logs/
echo - report.html (Relatório visual)
echo - log.html (Log detalhado)
echo - output.xml (Dados estruturados)
echo.

REM Pergunta se quer abrir o relatório
set /p open_report="Deseja abrir o relatório? (s/n): "
if /i "%open_report%"=="s" (
    start ./logs/report.html
)

echo.
set /p continue="Deseja executar mais testes? (s/n): "
if /i "%continue%"=="s" goto :menu

:end
echo.
echo Obrigado por usar os testes da Cinema API!
pause