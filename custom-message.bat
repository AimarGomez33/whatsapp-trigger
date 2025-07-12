@echo off
echo.
echo 💬 SIMULADOR DE MENSAJE PERSONALIZADO RÁPIDO
echo ============================================
echo.

cd /d "c:\Users\jair_\Desktop\trigger"

if "%1"=="" (
    echo 📝 Uso: custom-message.bat "Tu mensaje aquí" "Nombre del remitente" "Número"
    echo.
    echo 💡 Ejemplos:
    echo    custom-message.bat "¡Hola mundo!" "Ana García" "5215551234567"
    echo    custom-message.bat "Prueba de emoji 😊" "Carlos López"
    echo    custom-message.bat "Solo un mensaje"
    echo.
    
    set /p mensaje="💬 Escribe tu mensaje: "
    set /p nombre="👤 Nombre del remitente (opcional): "
    set /p numero="📱 Número del remitente (opcional): "
    
    if "%nombre%"=="" set nombre=Usuario Personalizado
    if "%numero%"=="" set numero=5215551234567
    
    echo.
    echo 📋 Enviando mensaje personalizado...
    echo 👤 De: %nombre% (+%numero%)
    echo 💬 Mensaje: "%mensaje%"
    echo.
    
    node simulate-message.js custom "%mensaje%" "%nombre%" "%numero%"
) else (
    echo 📋 Enviando mensaje con parámetros...
    node simulate-message.js custom %1 %2 %3
)

echo.
echo ===========================================
echo 💡 Otros comandos útiles:
echo    simulate.bat          - Menu completo
echo    node simulate-message.js custom - Modo interactivo
echo    node simulate-message.js help   - Ver ayuda
echo ===========================================
echo.
pause
