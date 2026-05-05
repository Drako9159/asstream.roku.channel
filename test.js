const https = require('https');
const http = require('http');

/**
 * Función auxiliar para realizar peticiones GET nativas
 */
function getJSON(urlStr) {
    return new Promise((resolve, reject) => {
        const protocol = urlStr.startsWith('https') ? https : http;
        protocol.get(urlStr, (res) => {
            let body = "";
            res.on("data", (chunk) => body += chunk);
            res.on("end", () => {
                try {
                    resolve(JSON.parse(body));
                } catch (error) {
                    reject(new Error(`Error parseando JSON desde ${urlStr}`));
                }
            });
        }).on("error", (error) => reject(error));
    });
}

/**
 * Valida si un stream está online usando el método HEAD (híbrido HTTP/HTTPS)
 */
function checkStreamStatus(streamUrl) {
    return new Promise((resolve) => {
        if (!streamUrl || streamUrl === "N/A") return resolve(false);
        
        try {
            const parsedUrl = new URL(streamUrl);
            const protocol = parsedUrl.protocol === 'https:' ? https : http;

            const req = protocol.request(streamUrl, {
                method: 'HEAD',
                timeout: 6000 // 6 segundos de espera
            }, (res) => {
                // Consideramos online si el status es 200-399
                resolve(res.statusCode >= 200 && res.statusCode < 400);
            });

            req.on('error', () => resolve(false));
            req.on('timeout', () => {
                req.destroy();
                resolve(false);
            });
            req.end();
        } catch (e) {
            resolve(false);
        }
    });
}

async function startDiscovery() {
    console.log("--- INICIANDO DISCOVERY IPTV (SPA + ENTERTAINMENT) ---");
    console.time("Duración total");

    try {
        // 1. Descarga de datos base de IPTV-ORG
        console.log("1/3 Descargando catálogos...");
        const [channels, feeds, streams] = await Promise.all([
            getJSON("https://iptv-org.github.io/api/channels.json"),
            getJSON("https://iptv-org.github.io/api/feeds.json"),
            getJSON("https://iptv-org.github.io/api/streams.json")
        ]);

        // 2. Filtrado lógico (Idiomas -> Canales -> Streams)
        console.log("2/3 Filtrando canales por idioma y categoría...");
        
        // Identificamos IDs de canales que tienen feed en español
        const spanishChannelIds = new Set(
            feeds.filter(f => f.languages && f.languages.includes('spa')).map(f => f.channel)
        );

        // Filtramos canales de entretenimiento que hablen español
        const candidates = channels
            .filter(c => 
                c.categories && 
                c.categories.includes('movies') && 
                spanishChannelIds.has(c.id)
            )
            .map(channel => {
                const stream = streams.find(s => s.channel === channel.id);
                return {
                    name: channel.name,
                    id: channel.id,
                    url: stream ? stream.url : "N/A"
                };
            })
            .filter(c => c.url !== "N/A");

        console.log(`Candidatos encontrados: ${candidates.length}`);

        // 3. Validación de disponibilidad (Check de red)
        console.log("3/3 Verificando streams online (esto puede tardar unos segundos)...");
        
        const results = await Promise.all(
            candidates.map(async (canal) => {
                const isOnline = await checkStreamStatus(canal.url);
                return isOnline ? canal : null;
            })
        );

        // Limpiamos los resultados offline
        const finalList = results.filter(c => c !== null);

        console.log("\n--- RESULTADOS FINALES ---");
        if (finalList.length > 0) {
            console.table(finalList);
            console.log(`Total canales funcionales encontrados: ${finalList.length}`);
        } else {
            console.log("No se encontraron canales online en este momento.");
        }

    } catch (err) {
        console.error("\n[!] Error crítico durante la ejecución:");
        console.error(err.message);
    }

    console.timeEnd("Duración total");
}

startDiscovery();
