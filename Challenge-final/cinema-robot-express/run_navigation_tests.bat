@echo off
echo ========================================
echo Cinema E2E - Testes de Navegação
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
echo 1. Executar todos os testes de navegação
echo 2. Testes de cabeçalho e menu
echo 3. Testes de responsividade
echo 4. Testes de usuário autenticado
echo 5. Testes de breadcrumbs e navegação
echo 6. Testes de acessibilidade
echo 7. Testes de performance
echo 0. Sair
echo.

set /p choice="Digite sua escolha (0-7): "

if "%choice%"=="0" goto :end
if "%choice%"=="1" goto :all_navigation_tests
if "%choice%"=="2" goto :header_tests
if "%choice%"=="3" goto :responsive_tests
if "%choice%"=="4" goto :authenticated_tests
if "%choice%"=="5" goto :breadcrumbs_tests
if "%choice%"=="6" goto :accessibility_tests
if "%choice%"=="7" goto :performance_tests

echo Opção inválida!
goto :menu

:all_navigation_tests
echo Executando todos os testes de navegação...
robot -d ./logs tests/navigation.robot
goto :show_results

:header_tests
echo Executando testes de cabeçalho e menu...
robot -d ./logs -i header tests/navigation.robot
goto :show_results

:responsive_tests
echo Executando testes de responsividade...
robot -d ./logs -i responsive tests/navigation.robot
goto :show_results

:authenticated_tests
echo Executando testes de usuário autenticado...
robot -d ./logs -i authenticated tests/navigation.robot
goto :show_results

:breadcrumbs_tests
echo Executando testes de breadcrumbs e navegação...
robot -d ./logs -i breadcrumbs -i flow tests/navigation.robot
goto :show_results

:accessibility_tests
echo Executando testes de acessibilidade...
robot -d ./logs -i accessibility tests/navigation.robot
goto :show_results

:performance_tests
echo Executando testes de performance...
robot -d ./logs -i performance tests/navigation.robot
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
echo Obrigado por usar os testes de navegação!
pause