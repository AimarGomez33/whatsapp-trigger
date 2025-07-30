const { Client, LocalAuth } = require('whatsapp-web.js');

console.log('🔍 Iniciando diagnóstico de eventos de mensajes...');

const client = new Client({
    authStrategy: new LocalAuth({
        clientId: "main-client"
    }),
    puppeteer: { 
        headless: false,
        args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-dev-shm-usage']
    }
});

client.on('qr', (qr) => {
    console.log('📱 Código QR generado. Escanéalo con tu teléfono.');
});

client.on('ready', () => {
    console.log('✅ Cliente de WhatsApp conectado y listo!');
    console.log('📋 Esperando mensajes entrantes...');
    console.log('💡 Envía un mensaje a tu número de WhatsApp para probar.');
    console.log('---');
});

client.on('message', msg => {
    console.log('🔔 EVENTO MESSAGE DETECTADO:');
    console.log(`📱 De: ${msg.from}`);
    console.log(`👤 Autor: ${msg.author || 'N/A'}`);
    console.log(`💬 Mensaje: ${msg.body}`);
    console.log(`⏰ Timestamp: ${new Date().toISOString()}`);
    console.log(`📍 Tipo: ${msg.type}`);
    console.log(`🏷️ Es grupo: ${msg.isGroupMsg}`);
    console.log(`👁️ Es de mi: ${msg.fromMe}`);
    console.log('---');
});

client.on('message_create', msg => {
    console.log('✨ EVENTO MESSAGE_CREATE DETECTADO:');
    console.log(`📱 De: ${msg.from}`);
    console.log(`👤 Autor: ${msg.author || 'N/A'}`);
    console.log(`💬 Mensaje: ${msg.body}`);
    console.log(`⏰ Timestamp: ${new Date().toISOString()}`);
    console.log(`📍 Tipo: ${msg.type}`);
    console.log(`🏷️ Es grupo: ${msg.isGroupMsg}`);
    console.log(`👁️ Es de mi: ${msg.fromMe}`);
    console.log('---');
});

client.on('authenticated', () => {
    console.log('🔐 Cliente autenticado correctamente');
});

client.on('auth_failure', msg => {
    console.error('❌ Error de autenticación:', msg);
});

client.on('disconnected', (reason) => {
    console.log('🔌 Cliente desconectado:', reason);
});

console.log('🚀 Iniciando cliente de WhatsApp...');
client.initialize();

// Mantener el proceso vivo
process.on('SIGINT', () => {
    console.log('\n🛑 Deteniendo diagnóstico...');
    client.destroy();
    process.exit(0);
});
