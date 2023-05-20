# 5.0 RicercaInFile&Output

## 5.1 Ridirezione input/output

- `stdin`, stream di input al comando, rappresentato da:
  - `0`
  - `$0`
  - `/dev/stdin`
- `stdout`, output che viene stampato a terminale, rappresentato da:
  - `1`
  - `$1`
  - `/dev/stdout`
- `stderr`, output che viene stampato a terminale esclusivo per il logging di errori, rappresentato da:
  - `2`
  - `$2`
  - `/dev/stderr`

Comandi di ridirezione di `stdout`:

- `>file` cancella il contenuto dentro `file` e poi ci scrive dentro
- `>>file` scrive dentro `file` in append mode

Comandi di ridirezione di `stderr`:

- `2>file` cancella il contenuto dentro `file` e poi ci scrive dentro
- `2>>file` scrive dentro `file` in append mode

Ridirezione sia di `stdout`, che di `stderr` si ottiene con: `&>file` o `&>>file`

Ridirezione di `stderr` in `stdout` si ottiene con: `2>&1`

Si possono fare multiple ridirezioni in un unico comando:\
(**N.B. la ridirezione è interpretata da destra verso sinistra**)

- `>file 2>error_file`, ridireziono:
  - `stderr` dentro `error_file`
  - `stdout` dentro `file`
- `>>file 2>>error_file`, ridireziono:
  - `stderr` dentro `error_file` in append
  - `stdout` dentro `file` in append
- `>file 2>&1`, ridireziono:
  - `stderr` in `stdout`
  - `stdout` dentro `file`

Ridirezione di contenuto dentro `stdin`:

- `cmd <file` ridireziono:
  - contenuto di `file` nello `stdin` di `cmd`
- `cmd <<marker` `cmd` legge da stdin(input da tty) fino a trovare `marker` (utile per helper `cat <<EOF`)
- `cmd <<<string` manda `string` direttamente allo stdin di `cmd`

Per eseguire una ridirezione definitiva (per questo processo shell ed i figli) si utilizza il comando `exec`, esempio:\

```bash
$ exec 2>/dev/null
$ exec 3>filein
$ exec 4<filein
$ echo "string">&3 # "string" verrà ridirezionato dentro filein
$ cat <&4 # leggerà da filein
  string
$ exec 3>&-
$ exec 4<&-
```

Per ignorare l'output di `stdin` o `stdout`:

- `>/dev/null` ignoro `stdin`
- `2>/dev/null` ignoro `stdout`

## 5.2 Piping

Per passare lo `stdout` di un comando allo `stdin` di un altro comando si può usare il carattere: `|`\
Per esempio, per contare i file dentro la directory corrente: `ls -l | tail +2 | wc -l`

`grep` è un comando di filtro su:

- `stdin`, per esempio `cat file | grep <string>`
- `file`, per esempio `grep <string> file`

## 5.3 Lettura realtime di un file

Se si vuole consultare un file di log in modo interattivo:

- `less +F <file>` (con il vantaggio del comando `v` per aprire il log in un editor dopo `Ctrl+c`)
- `tail -n+0 -f <file>`
