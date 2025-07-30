const axios = require('axios');
require('dotenv').config();

async function testCurrentWebhook() {
    const webhookUrl = process.env.WEBHOOK_URL;
    
    if (!webhookUrl) {
        console.log('❌ No hay WEBHOOK_URL en .env');
        return;
    }

    console.log('🧪 PRUEBA DE WEBHOOK');
    console.log('=' .repeat(40));
    console.log(`🔗 URL: ${webhookUrl}`);
    console.log('');

    // Simular un mensaje real como el que enviaríamos
    const testMessage = {
        id: `test_${Date.now()}`,
        from: '5217711270118@c.us',
        body: 'Mensaje de prueba para webhook',
        timestamp: Date.now(),
        type: 'chat',
        contact: {
            name: 'Test User',
            number: '5217711270118',
            isMyContact: false
        },
        isGroup: false,
        groupName: null
    };

    console.log('📦 Datos a enviar:');
    console.log(JSON.stringify(testMessage, null, 2));
    console.log('');

    try {
        console.log('📤 Enviando POST request...');
        
        const response = await axios.post(webhookUrl, testMessage, {
            headers: {
                'Content-Type': 'application/json',
                'User-Agent': 'WhatsApp-Test-Bot/1.0'
            },
            timeout: 15000
        });

        console.log('✅ RESPUESTA EXITOSA:');
        console.log(`   📊 Status: ${response.status}`);
        console.log(`   📄 Status Text: ${response.statusText}`);
        console.log('   📋 Headers:');
        Object.entries(response.headers).forEach(([key, value]) => {
            console.log(`      ${key}: ${value}`);
        });
        
        console.log('   📦 Data (primeros 500 chars):');
        const responseData = typeof response.data === 'object' 
            ? JSON.stringify(response.data, null, 2)
            : String(response.data);
        console.log(`      ${responseData.substring(0, 500)}${responseData.length > 500 ? '...' : ''}`);
        
        // Verificar si parece una respuesta de webhook válida
        if (typeof response.data === 'string' && response.data.includes('<html>')) {
            console.log('');
            console.log('⚠️  ALERTA: La respuesta contiene HTML');
            console.log('   Esto indica que el webhook no está procesando correctamente');
            console.log('   Posibles causas:');
            console.log('   - El workflow de n8n no está activo');
            console.log('   - La URL del webhook es incorrecta');
            console.log('   - Hay un proxy/firewall bloqueando');
        } else if (response.status === 200) {
            console.log('');
            console.log('✅ El webhook parece estar funcionando correctamente');
        }

    } catch (error) {
        console.log('❌ ERROR EN WEBHOOK:');
        
        if (error.response) {
            console.log(`   📊 Status: ${error.response.status}`);
            console.log(`   💬 Status Text: ${error.response.statusText}`);
            console.log('   📋 Headers:');
            Object.entries(error.response.headers || {}).forEach(([key, value]) => {
                console.log(`      ${key}: ${value}`);
            });
            console.log('   📦 Error Data:');
            console.log(`      ${JSON.stringify(error.response.data).substring(0, 300)}...`);
        } else if (error.request) {
            console.log('   🌐 No se recibió respuesta del servidor');
            console.log('   📋 Detalles del request:');
            console.log(`      URL: ${error.config?.url}`);
            console.log(`      Method: ${error.config?.method}`);
            console.log(`      Timeout: ${error.config?.timeout}ms`);
        } else {
            console.log(`   ⚠️  Error de configuración: ${error.message}`);
        }
    }
    
    console.log('');
    console.log('🏁 Prueba de webhook completada');
}

// Ejecutar la prueba
testCurrentWebhook();
