# 🚀 WhatsApp Webhook Trigger - Guía de Inicio Rápido

## 📋 Qué necesitas

1. **Node.js** instalado (versión 14 o superior)
2. **WhatsApp** en tu teléfono
3. **Conexión a internet** estable

## 🎯 Inicio rápido (3 pasos)

### 1. Instalar dependencias
```bash
npm install
```

### 2. Iniciar el servidor principal
```bash
# En Windows
start.bat

# En otros sistemas
npm start
```

### 3. Iniciar el servidor de pruebas (nueva terminal)
```bash
# En Windows
start-webhook-server.bat

# En otros sistemas
node src/test-webhook-server.js
```

## 📱 Primera configuración

1. **Ejecuta el servidor principal** - aparecerá un código QR en la terminal
2. **Abre WhatsApp** en tu teléfono
3. **Ve a Configuración > Dispositivos vinculados**
4. **Escanea el código QR** que aparece en la terminal
5. **¡Listo!** - verás "WhatsApp Web is ready!" en la consola

## 🧪 Probar que funciona

### Opción 1: Envía un mensaje a tu número
1. Envía un mensaje de WhatsApp a tu número desde otro teléfono
2. Ve la consola - deberías ver "📱 Mensaje recibido"
3. Abre http://localhost:3001 para ver el monitor web

### Opción 2: Usar los scripts de prueba
```bash
# Verificar estado
node examples/api-examples.js status

# Prueba completa
node examples/api-examples.js test

# Probar webhook
node examples/api-examples.js webhook
```

## 🔗 URLs importantes

- **🏠 Página principal**: http://localhost:3000 (¡NUEVA! Panel de control completo)
- **📊 Monitor web**: http://localhost:3001 (Para ver mensajes recibidos)
- **⚙️ Estado del servidor**: http://localhost:3000/status (JSON)
- **📱 Código QR**: http://localhost:3000/qr (Si no está conectado)
- **📡 Webhook endpoint**: http://localhost:3001/webhook/whatsapp

## 🛠️ Configuración básica

Edita el archivo `.env`:

```env
# Puerto del servidor principal
PORT=3000

# URL donde enviar los mensajes (webhook)
WEBHOOK_URL=http://localhost:3001/webhook/whatsapp

# Activar modo debug
DEBUG=true
```

## 📤 Enviar mensajes por API

```bash
curl -X POST http://localhost:3000/send-message \
  -H "Content-Type: application/json" \
  -d '{
    "number": "5215551234567",
    "message": "Hola desde la API!"
  }'
```

## 🔧 Integrar con n8n

1. **Crea un webhook trigger** en n8n
2. **Copia la URL del webhook** de n8n
3. **Cambia WEBHOOK_URL** en `.env` por tu URL de n8n
4. **Reinicia el servidor**

Ejemplo de flujo n8n:
```
Webhook → Function Node → HTTP Request → ...
```

## 🚨 Problemas comunes

### ❌ "WhatsApp not ready"
- Espera a que aparezca "WhatsApp Web is ready!"
- Si no aparece, escanea el código QR otra vez

### ❌ "ECONNREFUSED"
- Verifica que el servidor de webhooks esté corriendo en puerto 3001
- Cambia la URL en `.env` si usas otro puerto

### ❌ Código QR no aparece
- Elimina la carpeta `.wwebjs_auth`
- Reinicia el servidor

### ❌ Los mensajes no llegan al webhook
- Verifica que `WEBHOOK_URL` esté correcto en `.env`
- Revisa los logs en la consola

## 📋 Próximos pasos

1. **Cambia la configuración** en `.env` según tus necesidades
2. **Integra con tu sistema** usando la API REST
3. **Configura múltiples webhooks** para redundancia
4. **Añade autenticación** si es necesario

## 🆘 ¿Necesitas ayuda?

1. Verifica el archivo `README.md` para documentación completa
2. Revisa los logs en la consola
3. Usa http://localhost:3000/status para verificar el estado
4. Prueba con el servidor de webhooks incluido primero

---

**¡Ya estás listo para automatizar WhatsApp!** 🎉
