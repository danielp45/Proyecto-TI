FASTA_DIR="draft_assemblies"      
OUT_DIR="resultados_TBP"          
mkdir -p "$OUT_DIR"               

for fasta in "$FASTA_DIR"/*.fasta; do
    id=$(basename "$fasta".fasta)
    echo "Procesando ${id}..."
    tb-profiler profile --fasta "$fasta".fasta -p "$OUT_DIR/tb-${id}"
done

echo "✅ Análisis completado. Resultados en: $OUT_DIR/"


#!/bin/bash
FASTA_DIR="draft_assemblies"
OUT_DIR="resultados_TBP"

# Crear carpeta de salida si no existe
mkdir -p "$OUT_DIR"

# Recorrer todos los archivos con extensión .fasta
for fasta in "$FASTA_DIR"/*.fasta; do
    id=$(basename "$fasta" .fasta)   # quitar extensión .fasta
    echo "🔹 Procesando ${id}..."
    tb-profiler profile --fasta "$fasta" -p "$OUT_DIR/tb-${id}"
done

echo "✅ Análisis completado. Resultados en: $OUT_DIR/"

