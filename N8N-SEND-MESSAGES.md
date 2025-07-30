# 📱 Enviar Mensajes de WhatsApp desde n8n

## 🎯 Cómo funciona el flujo completo:

### 1. **Recibir mensajes** → WhatsApp → Tu sistema → n8n
### 2. **Enviar mensajes** → n8n → Tu sistema → WhatsApp

## 🚀 Endpoint para enviar mensajes:

Tu sistema ya tiene un endpoint listo para recibir mensajes desde n8n:

```
POST http://localhost:3000/send-message
```

## 📋 Formato del mensaje desde n8n:

```json
{
  "number": "5215551234567",
  "message": "¡Hola! Este mensaje viene desde n8n",
  "media": {
    "type": "image",
    "url": "https://example.com/imagen.jpg",
    "caption": "Descripción de la imagen"
  }
}
```

## 🔧 Configuración en n8n:

### 1. **Nodo HTTP Request** (para enviar mensajes):
```
Method: POST
URL: http://localhost:3000/send-message
Headers:
  Content-Type: application/json
Body:
{
  "number": "{{ $json.contact.number }}",
  "message": "Tu respuesta personalizada aquí"
}
```

### 2. **Ejemplo de workflow completo**:

```
Webhook → Procesar mensaje → HTTP Request (respuesta)
```

## 💡 Ejemplos prácticos:

### Respuesta automática simple:
```json
{
  "number": "{{ $json.data.message.from.split('@')[0] }}",
  "message": "¡Gracias por tu mensaje! Te responderé pronto."
}
```

### Respuesta con datos del mensaje original:
```json
{
  "number": "{{ $json.data.message.from.split('@')[0] }}",
  "message": "Recibí tu mensaje: '{{ $json.data.message.body }}'. ¡Gracias!"
}
```

### Respuesta con imagen:
```json
{
  "number": "{{ $json.data.message.from.split('@')[0] }}",
  "message": "¡Aquí tienes la imagen solicitada!",
  "media": {
    "type": "image",
    "url": "https://example.com/imagen.jpg",
    "caption": "Descripción de la imagen"
  }
}
```

## 🧪 Pruebas:

### 1. **Prueba directa con curl**:
```bash
curl -X POST http://localhost:3000/send-message \
  -H "Content-Type: application/json" \
  -d '{
    "number": "5215551234567",
    "message": "¡Hola desde n8n!"
  }'
```

### 2. **Prueba con Postman**:
```
POST http://localhost:3000/send-message
Content-Type: application/json

{
  "number": "5215551234567",
  "message": "Mensaje de prueba"
}
```

## 📊 Respuestas del servidor:

### ✅ **Éxito**:
```json
{
  "success": true,
  "result": {
    "messageId": "msg_123456",
    "timestamp": "2025-07-16T10:30:00Z"
  }
}
```

### ❌ **Error**:
```json
{
  "error": "Failed to send message",
  "details": "Chat not found"
}
```

## 🔄 Workflow completo en n8n:

1. **Webhook** → Recibe mensaje de WhatsApp
2. **Procesar** → Analiza el mensaje y decide respuesta
3. **HTTP Request** → Envía respuesta de vuelta por WhatsApp

## 📋 Campos disponibles en el webhook:

Cuando n8n recibe un mensaje, tienes estos datos disponibles:

```javascript
$json.data.message.from        // Número del remitente
$json.data.message.body        // Texto del mensaje
$json.data.message.timestamp   // Fecha/hora
$json.data.contact.name        // Nombre del contacto
$json.data.contact.number      // Número limpio
$json.data.message.isGroup     // Si es grupo
$json.data.message.groupName   // Nombre del grupo
```

## 🎯 Próximos pasos:

1. **Configura el webhook** en n8n (ya está listo)
2. **Agrega nodo HTTP Request** para enviar respuestas
3. **Prueba el flujo completo**
4. **Personaliza las respuestas** según tu lógica

¡Tu sistema está listo para enviar y recibir mensajes de WhatsApp a través de n8n!
