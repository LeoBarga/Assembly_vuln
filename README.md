# Programma Assembly VULNERABILE a buffer overflow

Questo progetto consente di testare in prima persona un buffer overflow e il suo funzionamento
a livello di codice Assembly e mostra la sua "controparte" in C++ come metodo di paragone.

> ⚠️ **ATTENZIONE**  
> - Questo codice è **VOLUTAMENTE** vulnerabile e si sconsiglia fortemente il suo utilizzo in ambienti non di laboratorio o comunque non controllati.  
> - Modificando il codice l'overflow può provocare **malfunzionamenti e crash**, si consiglia di fare attenzione prima di modificarlo/avviarlo e di utilizzare una macchina virtuale "sacrificabile".
> - Il payload è stato creato appositamente per questo programma per motivi **didattici e di test**, ***l'autore declina ogni responsabilità per l'uso improprio di questo codice.***


---

## Funzionamento

- *My_function* alloca 16 byte nello stack ma legge fino a 64 byte.
- Ogni dato oltre 16 byte va quindi a sovrascrivere altre variabili, l'ebp e l'indirizzo salvato da call (che è spesso l'obiettivo degli exploit basati su questa vulnerabilità).
- *Vulnerabile* potrebbe essere raggiunto con un input apposito, scrivendo come indirizzo di ritorno (quello di call) l’indirizzo di questa label.
- Il file *exploit.py* crea un buffer per sovrascrivere l'indirizzo di ritorno della funzione `my_function`, facendo in modo che il programma salti alla label `vulnerabile` e stampi il messaggio "Overflow riuscito!" senza chiamarla direttamente.

---

## Requisiti

- Macchina virtuale Linux
- Assembler NASM
- (OPZIONALE : Debugger GDB)

Per installare `nasm` e `gdb`, esegui i comandi:

```bash
sudo apt update
sudo apt install nasm
sudo apt install gdb
```

---

## Utilizzo

1. Copia il codice nella tua MV.
2. Crea un file .asm con:
```bash
nano file.asm
```
3. Incolla il codice e salva con CTRL+X
4. Rendi il file eseguibile con i seguenti comandi:
```bash
nasm -f elf32 -o file.o file.asm
ld -m elf_i386 -o file file.o
chmod 777 file
```
5. Avvia il programma con:
```bash
./file
```
6. Inserisci input

Con un input sufficientemente grande (tipo una serie di "A") si otterrà un overflow.

---

## Versione C++ e exploit Python

Per chi vuole approfondire, è disponibile anche la **versione C++ equivalente** e un **exploit Python** che dimostra come sia possibile manipolare il flusso di esecuzione con un payload costruito.

### Compilazione del codice C++

```bash
g++ -m32 file.cpp -o file -fno-stack-protector -z execstack -no-pie
```

> ℹ️ Queste opzioni disabilitano le protezioni moderne per rendere riproducibile il buffer overflow

### Esecuzione dell'exploit

1. Crea un file exploit.py e copia il codice al suo interno

2. Ottieni l’indirizzo esatto della funzione `vulnerabile` usando:
```bash
objdump -d file | grep vulnerabile
```

Sostituisci poi l'indirizzo nel file `exploit.py` nel campo:
```python
ret_address = struct.pack("<I", 0xXXXXXXXX)
```

3. Genera il payload:
```bash
python3 exploit.py
```

4. Inietta il payload nel programma vulnerabile:
```bash
cat payload | ./file
```

Se il payload è costruito correttamente, il programma stamperà:
```
Overflow riuscito!
```

---

## Note

- Visto l'aiuto non indifferente nella comprensione del linguaggio e nello svolgimento di questo progetto inserisco qua il link del manuale di Assembly liberamente consultabile online che ho consultato, scritto da Paul Carter e tradotto da Giacomo Bruschi: https://pacman128.github.io/static/pcasm-book-italian.pdf