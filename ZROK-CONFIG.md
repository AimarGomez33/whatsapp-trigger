# 🚀 CONFIGURACIÓN CORRECTA DE ZROK

## 🎯 Puerto actual: **3000** ✅

Tu servidor WhatsApp ya está corriendo en el puerto correcto: **3000**

## 🔧 Comandos correctos para zrok:

### 1. **Configuración básica:**
```cmd
zrok share public localhost:3000
```

### 2. **Con nombre personalizado (recomendado):**
```cmd
zrok share public --headless localhost:3000
```

### 3. **Para uso permanente:**
```cmd
zrok share public --headless --insecure localhost:3000
```

## 📋 Proceso completo:

### Paso 1: Asegúrate de que tu servidor esté corriendo
```cmd
# En una terminal
npm start

# Verifica que responda
curl http://localhost:3000/status
```

### Paso 2: Inicia zrok en OTRA terminal
```cmd
# En una segunda terminal
zrok share public localhost:3000
```

### Paso 3: Usa la URL que te da zrok
```
Tu URL será algo como: https://abc123.share.zrok.io
```

## 🧪 Prueba con la URL de zrok:

```cmd
curl -X POST https://TU-URL-ZROK.share.zrok.io/send-message \
  -H "Content-Type: application/json" \
  -d '{"number":"5217711270119","message":"Prueba desde zrok"}'
```

## ⚠️ IMPORTANTE:

### ✅ **Formato correcto:**
```json
{
  "number": "5217711270119",
  "message": "¡Hola desde zrok!"
}
```

### ❌ **Error común (NO hagas esto):**
```json
{
  "number": "5217711270119@c.us",  // ❌ NO incluyas @c.us
  "message": "mensaje"
}
```

## 🔍 Diagnóstico si sigue el error 502:

### 1. **Verifica que el servidor responda:**
```cmd
curl http://localhost:3000/status
```

### 2. **Reinicia zrok:**
```cmd
# Ctrl+C para detener zrok
zrok share public localhost:3000
```

### 3. **Verifica puertos ocupados:**
```cmd
netstat -an | findstr :3000
```

## 💡 **Solución paso a paso:**

1. **Terminal 1:** `npm start` (mantener corriendo)
2. **Terminal 2:** `zrok share public localhost:3000`
3. **Usar la nueva URL** que te da zrok
4. **Probar con JSON sin @c.us**

¿En qué paso específico tienes el problema?
