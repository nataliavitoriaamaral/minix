#!/bin/sh

set -eu

BIN=${BIN:-./teste_processos}
IO_OPS=${IO_OPS:-10000}
CPU_OPS=${CPU_OPS:-1000000}
OUTDIR=${OUTDIR:-resultados_FCFS}
RUNS=${RUNS:-3}

mkdir -p "$OUTDIR"

echo "nproc,run,io_count,io_avg_time,cpu_count,cpu_avg_time,total_avg_time" > "$OUTDIR/resumo.csv"
echo "nproc,run,tipo,proc_id,tempo" > "$OUTDIR/processos.csv"

for nproc in 50 100 200 500
do
    run=1
    while [ "$run" -le "$RUNS" ]
    do
        saida="$OUTDIR/saida_${nproc}_run${run}.txt"

        "$BIN" "$nproc" "$IO_OPS" "$CPU_OPS" > "$saida" 2> "$OUTDIR/stderr_${nproc}_run${run}.txt"

        io_count=$(grep -c '^IO' "$saida" || true)
        cpu_count=$(grep -c '^CPU' "$saida" || true)

        io_avg=$(awk '/^IO/ {sum += $3; n += 1} END {if (n > 0) printf "%.6f", sum / n; else printf "0"}' "$saida")
        cpu_avg=$(awk '/^CPU/ {sum += $3; n += 1} END {if (n > 0) printf "%.6f", sum / n; else printf "0"}' "$saida")
        total_avg=$(awk '(/^IO/ || /^CPU/) {sum += $3; n += 1} END {if (n > 0) printf "%.6f", sum / n; else printf "0"}' "$saida")

        awk -v nproc="$nproc" -v run="$run" '/^(IO|CPU)/ {printf "%s,%s,%s,%s,%s\n", nproc, run, $1, $2, $3}' "$saida" >> "$OUTDIR/processos.csv"

        printf "%s,%s,%s,%s,%s,%s,%s\n" \
            "$nproc" "$run" "$io_count" "$io_avg" "$cpu_count" "$cpu_avg" "$total_avg" \
            >> "$OUTDIR/resumo.csv"

        run=$((run + 1))
    done
done

echo "Resultados em: $OUTDIR"
echo "Resumo em: $OUTDIR/resumo.csv"