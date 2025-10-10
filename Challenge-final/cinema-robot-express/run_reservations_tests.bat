@echo off
echo ========================================
echo Cinema E2E - Testes de Sessões e Reservas
echo ========================================
echo.

REM Verifica se o frontend está rodando
echo Verificando se o frontend está rodando...
curl -s http://localhost:3000/ > nul
if %errorlevel% neq 0 (
    echo ERRO: Frontend não está rodando em http://localhost:3000
    echo Por favor, inicie o frontend primeiro:
    echo   cd ../cinema-challenge-front
    echo   npm run dev
    echo.
    pause
    exit /b 1
)

echo ✓ Frontend está rodando
echo.

REM Menu de opções
:menu
echo Escolha uma opção:
echo.
echo 1. Executar todos os testes de sessões e reservas
echo 2. Testes de sessões (US-SESSION-001)
echo 3. Testes de seleção de assentos (US-RESERVE-001)
echo 4. Testes de checkout (US-RESERVE-002)
echo 5. Testes de minhas reservas (US-RESERVE-003)
echo 6. Fluxo completo de reserva
echo 7. Testes negativos
echo 0. Sair
echo.

set /p choice="Digite sua escolha (0-7): "

if "%choice%"=="0" goto :end
if "%choice%"=="1" goto :all_reservations_tests
if "%choice%"=="2" goto :sessions_tests
if "%choice%"=="3" goto :seats_tests
if "%choice%"=="4" goto :checkout_tests
if "%choice%"=="5" goto :my_reservations_tests
if "%choice%"=="6" goto :complete_flow_tests
if "%choice%"=="7" goto :negative_tests

echo Opção inválida!
goto :menu

:all_reservations_tests
echo Executando todos os testes de sessões e reservas...
robot -d ./logs tests/sessions.robot tests/reservations.robot
goto :show_results

:sessions_tests
echo Executando testes de sessões...
robot -d ./logs tests/sessions.robot
goto :show_results

:seats_tests
echo Executando testes de seleção de assentos...
robot -d ./logs -i seats tests/reservations.robot
goto :show_results

:checkout_tests
echo Executando testes de checkout...
robot -d ./logs -i checkout tests/reservations.robot
goto :show_results

:my_reservations_tests
echo Executando testes de minhas reservas...
robot -d ./logs -i my-reservations tests/reservations.robot
goto :show_results

:complete_flow_tests
echo Executando fluxo completo de reserva...
robot -d ./logs -i positive tests/reservations.robot
goto :show_results

:negative_tests
echo Executando testes negativos...
robot -d ./logs -i negative tests/sessions.robot tests/reservations.robot
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
echo Obrigado por usar os testes de reservas!
pause