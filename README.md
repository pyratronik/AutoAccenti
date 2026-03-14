# AutoAccenti v2.x

🚀 **AutoAccenti** è un tool studiato per semplificare la scrittura in lingua italiana con tastiere dal layout non nativo e accelerare il flusso di digitazione, correggendo "al volo" e "intelligentemente" gli accenti!

La versione 2.x è stata riscritta e aggiornata per AutoHotkey v2 e rifinita **grazie al supporto di Gemini 3 flash/pro**.

## Cosa fa AutoAccenti?
Lo script monitora di nascosto ciò che digiti e converte magicamente l'apostrofo nell'accento corretto, rispettando tutte le principali regole grammaticali italiane:

- **Conversione Accenti:** Premi il tuo tasto "accento speciale" (di default `` ` ``) dopo una vocale o dopo un apostrofo preesistente.
  - Esempio: `e` + `` ` `` = `è`. Premendo di nuovo `` ` `` diventerà `é`.
- **Intelligenza e Monosillabi:** Conosce la grammatica italiana! Per parole di una sola sillaba che non richiedono l'accento (es. _blu_, _qui_, _tre_, _sto_, _su_, _do_, _re_) o lo richiedono (es. _giù_, _più_, _già_, _ciò_), lo aggiunge o lo nega automaticamente notificando l'utente tramite popup invisibili, ricordando sempre le eccezioni degli imperativi come _sta'_, _fa'_, _va'_.
- **Sostituzione parola intera:** Gestisce casi come `po'` convertendoli in automatico, o correzioni veloci con il tasto backspace.
- **Macchina del Tempo (BackShiftHistory):** Se digiti qualche carattere di troppo per errore e desideri mettere un accento sulla parola precedente, ti basta azionare **Backspace**: lo script "tornerà indietro" recuperando l'esatta history dei tasti premuti.
- **Micro Scorciatoie:** Digitando alcuni simboli tra parentesi hai i "punti forti" sottomano (es. `+/-` diventa `±`, `(c)` diventa `©`, `n_o` diventa `n°`).
- **Scorciatoie Alt Destro (per scrittura di testi in tedesco):** Digitando Right Alt (AltGr) in congiunzione con `a`, `o`, `u`, `s` compila la giusta versione di un umlaut o ß (`ä`, `ö`, `ü`, `ß`).

## Come eseguire il programma

Puoi lanciare semplicemente `AutoAccenti.exe` oppure passargli parametri utili da linea di comando a seconda delle tue esigenze.
Se sul tuo pc hai installato AutoHotkey v2, puoi lanciare lo script `AutoAccenti.ahk` 

### 1. Parametro per l'Apostrofo Speciale
Se non ti piace il carattere default `` ` `` (backtick), puoi passare il tuo "Tasto Accento" preferito all'avvio:
**Esempio (per usare l'apostrofo `'`):**
```bat
AutoAccenti.exe '
```

### 2. Parametro opzionale per la Tastiera Apple
Se utilizzi una **tastiera layout Apple MacOS**, puoi abilitare il parametro `apple`. Questa modalità scambia immediatamente i tasti Command e Option della mela mettendoli al loro orientamento analogo per Windows (scambia cioè le funzioni di Alt e Win).
**Esempio:**
```bat
AutoAccenti.exe apple
```
(Puoi usare indifferentemente `apple`, `-apple` o `/apple`).


*(Naturalmente i parametri possono essere utilizzati in contemporanea: `AutoAccenti.exe apple '`)*

---

### Enjoy AutoAccenti v2.x - Typo Free!
