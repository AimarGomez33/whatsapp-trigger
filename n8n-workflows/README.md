# 📁 Workflows de n8n - WhatsApp Automation

Este directorio contiene workflows listos para usar con tu WhatsApp Webhook Trigger.

## 🔄 Cómo importar workflows

1. **Abre n8n**: `https://jairgomez44.app.n8n.cloud`
2. **Nuevo workflow**: Clic en "+ New Workflow"
3. **Importar**: Clic en "⋯" → "Import from file"
4. **Seleccionar**: Elige uno de los archivos .json
5. **Activar**: Clic en "Active" para activarlo

---

## 📋 Workflows disponibles

### 1. 🤖 `basic-auto-response.json`
**Respuesta automática básica**

**Qué hace:**
- Recibe mensajes de WhatsApp
- Responde automáticamente con mensaje personalizado
- Registra logs para seguimiento

**Ideal para:**
- Empezar con WhatsApp automation
- Confirmación de recepción de mensajes
- Respuestas fuera de horario

**Nodos incluidos:**
- Webhook (recibe mensajes)
- Function (procesa mensaje)
- HTTP Request (envía respuesta)
- Respond to Webhook (confirma recepción)

---

### 2. 🧠 `intelligent-chatbot.json`
**Chatbot inteligente con múltiples respuestas**

**Qué hace:**
- Analiza el contenido del mensaje
- Responde según palabras clave:
  - "hola" → Saludo personalizado
  - "precio" → Lista de precios
  - "horario" → Horarios de atención
- Respuesta por defecto para otros mensajes

**Ideal para:**
- Atención al cliente automática
- Información de productos/servicios
- FAQ automatizado

**Palabras clave que detecta:**
- Saludos: "hola", "buenos", "buenas"
- Precios: "precio", "costo", "cuanto"
- Horarios: "horario", "hora", "atencion"

---

### 3. 📊 `google-sheets-integration.json`
**Integración con Google Sheets**

**Qué hace:**
- Guarda todos los mensajes en Google Sheets
- Registra datos completos (fecha, hora, contacto, mensaje)
- Genera estadísticas automáticas
- Envía respuesta de confirmación

**Configuración requerida:**
1. Crear Google Sheet con estas columnas:
   - Fecha, Hora, Nombre, Número, Mensaje, Tipo, Es Grupo, Nombre Grupo, Tiene Media, Es Contacto, ID Mensaje, Timestamp

2. Configurar Google Sheets credential en n8n

3. Cambiar `TU_GOOGLE_SHEET_ID_AQUI` por tu Sheet ID real

**Ideal para:**
- Base de datos de contactos
- Análisis de mensajes
- Seguimiento de conversaciones

---

## ⚙️ Configuración requerida

### Para todos los workflows:

1. **Webhook Path correcto:**
   ```
   webhook-test/a32dc71c-6d7a-4e45-b34c-0ddb30be916e
   ```

2. **HTTP Request URL:**
   ```
   http://localhost:3000/send-message
   ```

3. **WhatsApp Webhook Trigger corriendo:**
   ```bash
   npm start  # En c:\Users\jair_\Desktop\trigger
   ```

### Para Google Sheets workflow:

1. **Crear credential de Google Sheets en n8n**
2. **Configurar Sheet ID en el workflow**
3. **Crear Sheet con columnas específicas**

---

## 🎯 Personalización rápida

### Cambiar mensajes de respuesta:
Edita los Function Nodes y modifica la propiedad `message`:

```javascript
return {
  json: {
    number: contact.number,
    message: `Tu mensaje personalizado aquí 🎉`
  }
};
```

### Agregar nuevas palabras clave:
En el chatbot inteligente, modifica las condiciones del Switch:

```javascript
// En el Switch node, agregar nueva condición:
"contains(toLowerCase(), "nueva_palabra")"
```

### Cambiar horarios de atención:
```javascript
const hora = new Date().getHours();
const dia = new Date().getDay();

// Lunes a Viernes, 9 AM a 6 PM
if (dia >= 1 && dia <= 5 && hora >= 9 && hora <= 18) {
  // En horario
} else {
  // Fuera de horario
}
```

---

## 🧪 Testing

### 1. Test manual en n8n:
- Clic en "Execute Workflow" 
- Usar datos de prueba

### 2. Test real con WhatsApp:
- Enviar mensaje desde otro teléfono
- Verificar respuesta automática

### 3. Monitor en tiempo real:
- `http://localhost:3001` - Ver mensajes
- `http://localhost:3000/status` - Estado sistema

---

## 🔧 Troubleshooting

### ❌ Webhook no recibe datos:
1. Verifica que el workflow esté **Active**
2. Confirma el Path del webhook
3. Revisa logs en `http://localhost:3001`

### ❌ No se envían respuestas:
1. Verifica que WhatsApp esté conectado (`http://localhost:3000`)
2. Confirma URL del HTTP Request: `http://localhost:3000/send-message`
3. Revisa formato JSON en Function Node

### ❌ Error en Google Sheets:
1. Configura credential de Google Sheets
2. Verifica permisos del Sheet
3. Confirma que las columnas existen

---

## 📈 Próximos pasos

1. **Empezar con básico**: Importa `basic-auto-response.json`
2. **Evolucionar**: Migra a `intelligent-chatbot.json`
3. **Datos**: Agrega `google-sheets-integration.json`
4. **Personalizar**: Modifica según tu negocio
5. **Expandir**: Crea workflows propios

### 💡 Ideas para nuevos workflows:
- Sistema de citas/reservas
- Catálogo de productos con imágenes
- Encuestas de satisfacción
- Notificaciones por email/Slack
- Integración con CRM

---

**¡Tus workflows están listos para automatizar WhatsApp!** 🚀
