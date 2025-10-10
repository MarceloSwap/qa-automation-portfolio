@echo off
echo ========================================
echo Cinema E2E - Testes de Filmes
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
echo 1. Executar todos os testes de filmes
echo 2. Testes de lista de filmes (US-MOVIE-001)
echo 3. Testes de detalhes do filme (US-MOVIE-002)
echo 4. Testes de responsividade
echo 5. Testes de performance
echo 6. Testes negativos
echo 0. Sair
echo.

set /p choice="Digite sua escolha (0-6): "

if "%choice%"=="0" goto :end
if "%choice%"=="1" goto :all_movies_tests
if "%choice%"=="2" goto :movie_list_tests
if "%choice%"=="3" goto :movie_details_tests
if "%choice%"=="4" goto :responsive_tests
if "%choice%"=="5" goto :performance_tests
if "%choice%"=="6" goto :negative_tests

echo Opção inválida!
goto :menu

:all_movies_tests
echo Executando todos os testes de filmes...
robot -d ./logs tests/movies.robot
goto :show_results

:movie_list_tests
echo Executando testes de lista de filmes...
robot -d ./logs -i movie-list tests/movies.robot
goto :show_results

:movie_details_tests
echo Executando testes de detalhes do filme...
robot -d ./logs -i movie-details tests/movies.robot
goto :show_results

:responsive_tests
echo Executando testes de responsividade...
robot -d ./logs -i responsive tests/movies.robot
goto :show_results

:performance_tests
echo Executando testes de performance...
robot -d ./logs -i performance tests/movies.robot
goto :show_results

:negative_tests
echo Executando testes negativos...
robot -d ./logs -i negative tests/movies.robot
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
echo Obrigado por usar os testes de filmes!
pause