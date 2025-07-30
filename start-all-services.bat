@echo off
echo.
echo 🚀 GUÍA COMPLETA - LEVANTAR SERVICIOS WHATSAPP
echo =============================================
echo.

cd /d "c:\Users\jair_\Desktop\trigger"

echo 📋 SERVICIOS NECESARIOS:
echo.
echo 1. 🟢 Servidor WhatsApp (Puerto 3000) - PRINCIPAL
echo 2. 🟢 ngrok/zrok (Túnel público) - Para acceso externo
echo 3. 🟢 n8n (Tu instancia) - Para automatizaciones
echo.

echo ========================================
echo 🎯 PASO 1: SERVIDOR WHATSAPP (PRINCIPAL)
echo ========================================
echo.

:: Verificar dependencias
echo 🔍 Verificando dependencias...
if not exist "node_modules" (
    echo ❌ Dependencias no instaladas
    echo 📦 Instalando dependencias...
    npm install
    if errorlevel 1 (
        echo ❌ Error instalando dependencias
        pause
        exit /b 1
    )
) else (
    echo ✅ Dependencias instaladas
)

:: Verificar archivo .env
if not exist ".env" (
    echo ⚠️  Creando archivo .env...
    echo PORT=3000 > .env
    echo HOST=localhost >> .env
    echo WEBHOOK_URL=https://n8n-kubectl.42web.io/webhook/whatsapp-bot >> .env
    echo DEBUG=true >> .env
    echo ✅ Archivo .env creado
)

echo.
echo 🚀 INICIANDO SERVIDOR WHATSAPP...
echo.
echo ⚠️  IMPORTANTE:
echo - Mantén esta terminal abierta
echo - El servidor estará en http://localhost:3000
echo - Para detener: Ctrl+C
echo.

set /p start_server="¿Iniciar servidor WhatsApp ahora? (S/N): "

if /i "%start_server%"=="S" (
    echo.
    echo 📱 Iniciando servidor principal...
    echo.
    start "WhatsApp Server" cmd /k "cd /d %cd% && npm start"
    timeout /t 3 >nul
) else (
    echo 💡 Para iniciar manualmente: npm start
)

echo.
echo ========================================
echo 🌐 PASO 2: TÚNEL PÚBLICO (NGROK/ZROK)
echo ========================================
echo.

echo Opciones disponibles:
echo.
echo A) ngrok (Recomendado - más estable)
echo B) zrok (Alternativa gratuita)
echo.

set /p tunnel_choice="¿Qué túnel quieres usar? (A/B): "

if /i "%tunnel_choice%"=="A" (
    echo.
    echo 🔧 Configurando ngrok...
    ngrok version >nul 2>&1
    if errorlevel 1 (
        echo ❌ ngrok no está instalado
        echo 🔧 Instala desde: https://ngrok.com/download
        echo 📱 O ejecuta: winget install ngrok
        goto :n8n_check
    ) else (
        echo ✅ ngrok encontrado
        ngrok version
        
        set /p start_ngrok="¿Iniciar ngrok ahora? (S/N): "
        if /i "!start_ngrok!"=="S" (
            echo.
            echo 🌐 Iniciando ngrok en puerto 3000...
            start "ngrok Tunnel" cmd /k "ngrok http 3000"
            echo.
            echo ⚠️  IMPORTANTE:
            echo 1. Copia la URL HTTPS que aparezca (ej: https://abc123.ngrok.io)
            echo 2. Úsala para enviar mensajes desde n8n
            timeout /t 5 >nul
        )
    )
) else if /i "%tunnel_choice%"=="B" (
    echo.
    echo 🔧 Configurando zrok...
    zrok version >nul 2>&1
    if errorlevel 1 (
        echo ❌ zrok no está instalado
        echo 🔧 Instala desde: https://zrok.io/
        goto :n8n_check
    ) else (
        echo ✅ zrok encontrado
        zrok version
        
        set /p start_zrok="¿Iniciar zrok ahora? (S/N): "
        if /i "!start_zrok!"=="S" (
            echo.
            echo 🌐 Iniciando zrok en puerto 3000...
            start "zrok Tunnel" cmd /k "zrok share public localhost:3000"
            echo.
            echo ⚠️  IMPORTANTE:
            echo 1. Copia la URL HTTPS que aparezca
            echo 2. Úsala para enviar mensajes desde n8n
            timeout /t 5 >nul
        )
    )
)

:n8n_check
echo.
echo ========================================
echo 🤖 PASO 3: N8N (YA CONFIGURADO)
echo ========================================
echo.
echo Tu instancia n8n: https://n8n-kubectl.42web.io
echo Webhook configurado: https://n8n-kubectl.42web.io/webhook/whatsapp-bot
echo.
echo ✅ n8n ya está configurado y listo
echo 💡 Solo necesitas importar los workflows desde: n8n-workflows/
echo.

echo ========================================
echo 📋 RESUMEN DE SERVICIOS:
echo ========================================
echo.

:: Verificar servidor WhatsApp
echo 🔍 Verificando servidor WhatsApp...
curl -s http://localhost:3000/status >nul 2>&1
if errorlevel 1 (
    echo ❌ Servidor WhatsApp: NO corriendo
    echo 🔧 Ejecuta: npm start
) else (
    echo ✅ Servidor WhatsApp: Corriendo en puerto 3000
)

echo.
echo 🔍 Estado de servicios:
echo.
echo 1. 📱 WhatsApp Server: http://localhost:3000
if /i "%start_server%"=="S" (
    echo    Estado: ✅ INICIADO
) else (
    echo    Estado: ❌ No iniciado - Ejecuta: npm start
)

echo.
echo 2. 🌐 Túnel público:
if /i "%tunnel_choice%"=="A" (
    echo    Tipo: ngrok
    echo    Estado: Verifica la ventana de ngrok
) else if /i "%tunnel_choice%"=="B" (
    echo    Tipo: zrok  
    echo    Estado: Verifica la ventana de zrok
) else (
    echo    Estado: ❌ No configurado
)

echo.
echo 3. 🤖 n8n:
echo    URL: https://n8n-kubectl.42web.io
echo    Estado: ✅ Disponible
echo.

echo ========================================
echo 🎯 PRÓXIMOS PASOS:
echo ========================================
echo.
echo 1. Ve a http://localhost:3000
echo 2. Escanea el QR de WhatsApp (primera vez)
echo 3. Copia la URL del túnel (ngrok/zrok)
echo 4. Configura n8n con esa URL
echo 5. ¡Envía mensajes de prueba!
echo.

echo 💡 Scripts útiles:
echo   test-send-message.bat     - Enviar mensaje
echo   simulate.bat              - Simular mensajes
echo   diagnose-zrok.bat         - Diagnosticar problemas
echo.

pause

echo.
echo ========================================
echo 🧪 ¿EJECUTAR PRUEBA COMPLETA?
echo ========================================

set /p run_test="¿Quieres probar el sistema completo ahora? (S/N): "

if /i "%run_test%"=="S" (
    echo.
    echo 🧪 Ejecutando prueba completa...
    
    :: Esperar a que el servidor esté listo
    echo ⏳ Esperando a que el servidor esté listo...
    timeout /t 10 >nul
    
    :: Probar estado
    curl -s http://localhost:3000/status
    if errorlevel 1 (
        echo ❌ Servidor no responde
        echo 🔧 Asegúrate de que npm start esté corriendo
    ) else (
        echo ✅ Servidor funcionando
        echo.
        echo 📱 Abre http://localhost:3000 para conectar WhatsApp
        echo 🌐 Usa la URL del túnel para n8n
        start http://localhost:3000
    )
)

echo.
echo ========================================
echo ✅ SERVICIOS CONFIGURADOS
echo ========================================
