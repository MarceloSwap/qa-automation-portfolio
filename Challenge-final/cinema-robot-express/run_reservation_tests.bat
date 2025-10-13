@echo off
echo ========================================
echo    EXECUTANDO TESTES DE RESERVAS
echo ========================================
echo.

echo Executando testes de Selecao de Assentos (US-RESERVE-001)...
robot -d ./logs -i US-RESERVE-001 tests/CT-Reserve-001_Selecionar_Assentos.robot

echo.
echo Executando testes de Processo de Checkout (US-RESERVE-002)...
robot -d ./logs -i US-RESERVE-002 tests/CT-Reserve-002_Processo_Checkout.robot

echo.
echo Executando testes de Minhas Reservas (US-RESERVE-003)...
robot -d ./logs -i US-RESERVE-003 tests/CT-Reserve-003_Minhas_Reservas.robot

echo.
echo ========================================
echo    TODOS OS TESTES DE RESERVAS CONCLUIDOS
echo ========================================
echo.
echo Verifique os relatorios em: ./logs/
pause