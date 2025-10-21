#!/bin/bash

# Verificar que se proporcionó el archivo de entrada
if [ $# -eq 0 ]; then
    echo "Uso: $0 <archivo_sra_list.txt>"
    echo "El archivo debe contener una lista de accesiones SRA, una por línea"
    exit 1
fi

archivo_sra="$1"

# Verificar que el archivo existe
if [ ! -f "$archivo_sra" ]; then
    echo "Error: El archivo '$archivo_sra' no existe"
    exit 1
fi

echo "=== INICIANDO DESCARGA MASIVA DE SRA ==="
echo "Archivo de entrada: $archivo_sra"
echo "Total de accesiones: $(grep -c "SRR" "$archivo_sra")"
echo "========================================"

while IFS= read -r run; do
    # Saltar líneas vacías y comentarios
    if [[ -z "$run" || "$run" =~ ^# ]]; then
        continue
    fi
    
    # Verificar que es una accesión SRA válida
    if [[ ! "$run" =~ ^SRR ]]; then
        echo "⏭️  Saltando línea no válida: $run"
        continue
    fi
    
    echo "=== Procesando: $run ==="
    
    # Crear directorio con el nombre de la accesión
    mkdir -p "$run"
    
    # Descargar con prefetch
    echo "📥 Descargando SRA..."
    prefetch "$run" -O "$run" --output-file "$run/$run.sra"
    
    # Convertir a FASTQ
    echo "🔄 Extrayendo FASTQ..."
    fasterq-dump "$run" -O "$run" --split-files --progress
    
    # Limpiar archivos temporales
    if [ -d "$run/$run" ]; then
        mv "$run/$run"/*.fastq "$run/" 2>/dev/null
        rm -rf "$run/$run"
    fi
    
    if [ -f "$run/$run.sra" ]; then
        rm "$run/$run.sra"
        echo "🧹 Archivo temporal eliminado"
    fi
    
    echo "✅ Completado: $run"
    echo ""
    
done < metadata1C.txt

echo "🎉 ¡Todas las descargas completadas!"