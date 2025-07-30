@echo off
echo.
echo 🚀 DEPLOY RÁPIDO CON RAILWAY
echo ===========================
echo.

echo 📋 Pasos para deploy en Railway.app:
echo.
echo 1️⃣  PREPARACIÓN:
echo    - Ve a: https://railway.app
echo    - Registrate con GitHub
echo    - Instala Railway CLI
echo.
echo 2️⃣  INSTALACIÓN CLI:
echo    npm install -g @railway/cli
echo.
echo 3️⃣  DEPLOY:
echo    - railway login
echo    - railway init
echo    - railway up
echo.

set /p choice="¿Quieres que te ayude a hacer el deploy ahora? (y/n): "

if /i "%choice%"=="y" goto deploy
if /i "%choice%"=="s" goto deploy
goto end

:deploy
echo.
echo 🔄 Iniciando proceso de deploy...
echo.

:: Verificar si railway CLI está instalado
where railway >nul 2>&1
if errorlevel 1 (
    echo ❌ Railway CLI no está instalado
    echo 📦 Instalando Railway CLI...
    npm install -g @railway/cli
    
    if errorlevel 1 (
        echo ❌ Error instalando Railway CLI
        echo 🔧 Instala manualmente: npm install -g @railway/cli
        pause
        exit /b 1
    )
)

echo ✅ Railway CLI disponible
echo.

:: Verificar si ya hay un proyecto iniciado
if exist railway.toml (
    echo ℹ️  Proyecto Railway ya existe
    echo 🚀 Haciendo deploy...
    railway up
) else (
    echo 📋 Iniciando nuevo proyecto Railway...
    echo ℹ️  Se abrirá el navegador para autenticar
    railway login
    
    if errorlevel 1 (
        echo ❌ Error en login
        echo 🔧 Intenta manualmente: railway login
        pause
        exit /b 1
    )
    
    echo ✅ Login exitoso
    echo 📦 Creando proyecto...
    railway init
    
    echo 🚀 Haciendo primer deploy...
    railway up
)

echo.
echo ✅ Deploy completado!
echo.
echo 📋 Para obtener la URL de tu aplicación:
echo    railway status
echo    railway open
echo.
echo 🔧 Para futuros deploys:
echo    railway up
echo.
pause
goto end

:end
echo.
echo 💡 COMANDOS ÚTILES DE RAILWAY:
echo ==============================
echo railway status    - Ver estado y URL
echo railway logs      - Ver logs en tiempo real  
echo railway open      - Abrir la app en el navegador
echo railway up        - Deploy de cambios
echo railway link      - Conectar con proyecto existente
echo.
echo 🔗 Documentación: https://docs.railway.app
echo.
pause
