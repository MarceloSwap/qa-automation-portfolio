@echo off
echo Configurando dados de teste para a API do Cinema...

cd /d "c:\Users\marce\OneDrive\Documentos\PROJETOS\pb-compass\Challenge-final\cinema-challenge-back"

echo Instalando dependencias...
call npm install

echo Populando filmes...
node src/utils/seedData.js

echo Populando sessoes...
node src/utils/seedSessions.js

echo Configuracao concluida!
pause