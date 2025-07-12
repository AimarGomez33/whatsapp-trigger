const fs = require('fs');
const path = require('path');

console.log('🔍 Verificando instalación de WhatsApp Webhook Trigger...\n');

const checks = [
    {
        name: 'Node.js instalado',
        check: () => {
            try {
                const version = process.version;
                const majorVersion = parseInt(version.slice(1).split('.')[0]);
                return { success: majorVersion >= 14, info: version };
            } catch (error) {
                return { success: false, error: error.message };
            }
        }
    },
    {
        name: 'package.json existe',
        check: () => {
            const exists = fs.existsSync('package.json');
            return { success: exists };
        }
    },
    {
        name: 'node_modules instalado',
        check: () => {
            const exists = fs.existsSync('node_modules');
            return { success: exists };
        }
    },
    {
        name: 'Archivo .env configurado',
        check: () => {
            const exists = fs.existsSync('.env');
            if (exists) {
                const content = fs.readFileSync('.env', 'utf8');
                const hasWebhookUrl = content.includes('WEBHOOK_URL');
                return { success: hasWebhookUrl, info: hasWebhookUrl ? 'Configurado' : 'Falta WEBHOOK_URL' };
            }
            return { success: false, info: 'Archivo no existe' };
        }
    },
    {
        name: 'Archivos principales',
        check: () => {
            const files = [
                'src/index.js',
                'src/services/WhatsAppService.js',
                'src/services/WebhookService.js',
                'src/services/ApiService.js',
                'src/test-webhook-server.js'
            ];
            
            const missing = files.filter(file => !fs.existsSync(file));
            return { 
                success: missing.length === 0, 
                info: missing.length > 0 ? `Faltan: ${missing.join(', ')}` : 'Todos presentes' 
            };
        }
    },
    {
        name: 'Scripts de inicio',
        check: () => {
            const scripts = ['start.bat', 'start-webhook-server.bat'];
            const missing = scripts.filter(script => !fs.existsSync(script));
            return { 
                success: missing.length === 0, 
                info: missing.length > 0 ? `Faltan: ${missing.join(', ')}` : 'Disponibles' 
            };
        }
    }
];

let allPassed = true;

checks.forEach((check, index) => {
    const result = check.check();
    const status = result.success ? '✅' : '❌';
    const info = result.info ? ` (${result.info})` : '';
    const error = result.error ? ` - Error: ${result.error}` : '';
    
    console.log(`${index + 1}. ${status} ${check.name}${info}${error}`);
    
    if (!result.success) {
        allPassed = false;
    }
});

console.log('\n' + '='.repeat(50));

if (allPassed) {
    console.log('🎉 ¡Todo listo! Tu instalación está completa.\n');
    
    console.log('📋 Próximos pasos:');
    console.log('1. Ejecuta: start.bat (o npm start)');
    console.log('2. En otra terminal: start-webhook-server.bat');
    console.log('3. Escanea el código QR con WhatsApp');
    console.log('4. ¡Envía un mensaje para probar!\n');
    
    console.log('🔗 URLs importantes:');
    console.log('- Estado: http://localhost:3000/status');
    console.log('- Monitor: http://localhost:3001');
    console.log('- Webhook: http://localhost:3001/webhook/whatsapp\n');
    
    console.log('💡 Tip: Lee QUICK_START.md para una guía paso a paso');
} else {
    console.log('⚠️  Hay algunos problemas que resolver:\n');
    
    console.log('🔧 Soluciones sugeridas:');
    console.log('- Si falta Node.js: descarga desde https://nodejs.org/');
    console.log('- Si faltan node_modules: ejecuta "npm install"');
    console.log('- Si falta .env: el sistema lo creará automáticamente');
    console.log('- Si faltan archivos: verifica que descargaste todo el proyecto\n');
    
    console.log('📖 Para más ayuda, consulta README.md');
}

console.log('\n🚀 WhatsApp Webhook Trigger v1.0');
console.log('📧 Para soporte, revisa la documentación o abre un issue en GitHub');
