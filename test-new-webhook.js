const axios = require('axios');

async function testNewWebhook() {
    console.log('🎯 PROBANDO WEBHOOK DE PRODUCCIÓN');
    console.log('URL:', 'https://n8n-kubectl.42web.io/webhook/whatsapp-bot');
    console.log('='.repeat(60));

    // Mensaje de prueba
    const testMessage = {
        event: 'message_received',
        timestamp: new Date().toISOString(),
        data: {
            message: {
                id: 'test_message_' + Date.now(),
                from: '5215551234567@c.us',
                to: 'tu_numero@c.us',
                body: '¡Hola! Este es un mensaje de prueba para el nuevo webhook',
                type: 'chat',
                timestamp: Math.floor(Date.now() / 1000),
                isForwarded: false,
                isGroup: false,
                groupName: null,
                hasMedia: false,
                media: null,
                location: null,
                quotedMessage: null,
                links: [],
                mentions: []
            },
            contact: {
                id: '5215551234567@c.us',
                name: 'Usuario de Prueba',
                number: '5215551234567',
                isMyContact: true
            },
            metadata: {
                source: 'whatsapp-web-js',
                version: '1.0.0',
                processed_at: new Date().toISOString()
            }
        }
    };

    try {
        console.log('📤 Enviando mensaje de prueba...');
        
        const response = await axios.post(
            'https://n8n-kubectl.42web.io/webhook/whatsapp-bot',
            testMessage,
            {
                headers: {
                    'Content-Type': 'application/json',
                    'User-Agent': 'WhatsApp-Webhook-Test/1.0'
                },
                timeout: 10000
            }
        );

        console.log('✅ ¡WEBHOOK FUNCIONA CORRECTAMENTE!');
        console.log('📊 Status:', response.status);
        console.log('📄 Response:', response.data);
        console.log('🎉 Tu n8n workflow está recibiendo los datos');

        return true;

    } catch (error) {
        console.log('❌ ERROR EN EL WEBHOOK:');
        console.log('🔧 Error:', error.message);
        
        if (error.response) {
            console.log('📊 Status:', error.response.status);
            console.log('📄 Response:', error.response.data);
        }

        if (error.code === 'ECONNREFUSED') {
            console.log('🚨 El servidor n8n no responde');
        } else if (error.response?.status === 404) {
            console.log('🚨 Webhook no encontrado - verifica que:');
            console.log('   1. El workflow esté ACTIVO en n8n');
            console.log('   2. El path sea exactamente: webhook-test/whatsapp-bot');
            console.log('   3. El método sea POST');
        } else if (error.response?.status === 500) {
            console.log('🚨 Error interno en n8n - revisa el workflow');
        }

        return false;
    }
}

async function testFullFlow() {
    console.log('🧪 PRUEBA COMPLETA DEL FLUJO\n');

    // 1. Verificar configuración local
    console.log('1. 📋 Verificando configuración...');
    require('dotenv').config();
    
    const webhookUrl = process.env.WEBHOOK_URL;
    console.log('   Webhook URL configurada:', webhookUrl);
    
    if (webhookUrl !== 'https://n8n-kubectl.42web.io/webhook/whatsapp-bot') {
        console.log('   ⚠️ URL no coincide con la nueva. Actualizando...');
    } else {
        console.log('   ✅ URL correcta en .env');
    }

    // 2. Verificar servidor local
    console.log('\n2. 🏠 Verificando servidor local...');
    try {
        const statusResponse = await axios.get('http://localhost:3000/status');
        console.log('   ✅ Servidor local funcionando');
        console.log('   📱 WhatsApp conectado:', statusResponse.data.whatsapp_connected ? 'SÍ' : 'NO');
        
        if (!statusResponse.data.whatsapp_connected) {
            console.log('   🚨 ¡WhatsApp NO está conectado!');
            console.log('   🔧 Ve a http://localhost:3000 y escanea el QR');
            return;
        }
    } catch (error) {
        console.log('   ❌ Servidor local no responde');
        console.log('   🔧 Ejecuta: npm start');
        return;
    }

    // 3. Probar webhook
    console.log('\n3. 🎯 Probando webhook de n8n...');
    const webhookWorks = await testNewWebhook();

    // 4. Resumen
    console.log('\n' + '='.repeat(60));
    console.log('📋 RESUMEN:');
    
    if (webhookWorks) {
        console.log('✅ ¡TODO FUNCIONA PERFECTAMENTE!');
        console.log('');
        console.log('🎯 Próximos pasos:');
        console.log('1. Envía un WhatsApp a tu número desde OTRO teléfono');
        console.log('2. Ve los logs en la consola del servidor');
        console.log('3. Verifica las ejecuciones en n8n');
        console.log('');
        console.log('📱 URLs útiles:');
        console.log('   - Estado: http://localhost:3000');
        console.log('   - Monitor: http://localhost:3001');
        console.log('   - n8n: https://jairgomez44.app.n8n.cloud');
    } else {
        console.log('❌ Hay problemas que resolver');
        console.log('');
        console.log('🔧 Pasos para solucionar:');
        console.log('1. Verifica que el workflow esté ACTIVO en n8n');
        console.log('2. Confirma el path: webhook/whatsapp-bot');
        console.log('3. Método debe ser POST');
        console.log('4. Reinicia el servidor: npm start');
    }
}

// Ejecutar la prueba
testFullFlow().catch(console.error);
