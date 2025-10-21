#!/bin/bash
while IFS=$'\t' read -r id run; do
    # Saltar encabezados
    if [[ "$id" == "ID" || "$run" == "Run" ]]; then
        continue
    fi
    
    echo "=== Procesando: $id (SRA: $run) ==="
    
    # Crear directorio
    mkdir -p "$id"
    
    # Descargar con prefetch - EVITAR subcarpeta
    echo "Descargando SRA..."
    prefetch "$run" -O "$id" --output-file "$id/$run.sra"
    
    # Convertir a FASTQ
    echo "Extrayendo FASTQ..."
    fasterq-dump "$run" -O "$id" --split-files --progress
    
    # Limpiar carpetas temporales
    if [ -d "$id/$run" ]; then
        # Mover los archivos FASTQ si están en la subcarpeta
        mv "$id/$run"/*.fastq "$id/" 2>/dev/null
        rm -rf "$id/$run"
    fi
    
    if [ -f "$id/$run.sra" ]; then
        rm "$id/$run.sra"
        echo "Archivo temporal eliminado"
    fi
    
    echo "✅ Completado: $id"
    echo ""
    
done < metadata2C.txt
