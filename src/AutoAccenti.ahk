#Requires AutoHotkey v2
#SingleInstance Force
#UseHook                ; Forza l'uso del hook per tutte le hotkey
A_MaxHotkeysPerInterval := 800 ; Evita l'errore se si ricevono molti tasti (es. da potenziometri MIDI)

; --- Configurazione Icona Tray ---
if FileExist("assets\AutoAccenti.ico")
    TraySetIcon("assets\AutoAccenti.ico")
; ---------------------------------

; 2026-02-21 Nuova versione per AutoHotKey v2
; 2026-02-21 se si scrive -che'- lo modificava in -chu- anzichè in -che-
; 2026-02-21 Aumentato il tempo dei tooltip da 2 a 4 secondi
; 2026-03-13 Aggiunto il controllo per i monosillabi e gestione maiuscole
; 2026-03-15 Sistemato tal e qual con apostrofo e backtick
; 2026-03-16 Regole su (c)he, , re, (an)dò, (pe)rò e (p)uò

; Costanti globali
global NotaMonosillabi :=
    "si scrive senza accento come tutte le parole di una sillaba.`nUniche eccezioni: ché ciò dà dì è già giù là lì né più sé sì tè`no quando entrano a far parte di una parola composta"
global NotaImperativi :=
    "si scrive senza accento come tutte le parole di una sillaba.`nMa vuole l'apostrofo nell'imperativo come in sta'=stai fa'=fai va'= vai"
; Carattere inserito attivando la shortcut Alt + ' (da linea di comando o default)
global SpecialApostrophe := "``"
global AppleKeyboard := false

for arg in A_Args {
    if (StrLower(arg) = "apple" or StrLower(arg) = "-apple" or StrLower(arg) = "/apple")
        AppleKeyboard := true
    else if (StrLen(arg) = 1)
        SpecialApostrophe := arg
}

; Stato della tastiera (History)
global H := [" ", " ", " ", " ", " ", " ", " ", " ", " "]

; Diagnostica avvio
ToolTip("AutoAccenti v2 2026-03-16 Avviato!")
SetTimer () => ToolTip(), -4000

; Inizializzazione InputHook
; V = Visible (non blocca l'input dell'utente)
; I = Ignore script generated input (evita ricorsione)
ih := InputHook("V I")
ih.OnChar := ProcessKey
ih.Start()

; Creazione dinamica delle hotkey per l'inserimento dell'apostrofo/carattere speciale
; (*) => scarta i parametri extra passati dalla hotkey
Hotkey("<^>!" SpecialApostrophe, (*) => SendSpecialChar(SpecialApostrophe))
Hotkey("!" SpecialApostrophe, (*) => SendSpecialChar(SpecialApostrophe))

ProcessKey(ih, char) {
    if (char = SpecialApostrophe or char = "'" or char = " " or char = "ù" or char = "à" or char = "è" or char = "é" or
        char = "ì" or
        char = "ò") {
        KeyCheck(char)
    } else {
        ShiftHistory(char)
    }
}

ShiftHistory(key) {
    global H
    H.Pop()
    H.InsertAt(1, key)
}

KeyCheck(key) {
    global NotaMonosillabi, NotaImperativi, H

    ; Se la history è vuota (es. dopo spostamento cursore) e si preme l'apostrofo,
    ; cerca di leggere il carattere precedente dal testo in modo selettivo.
    if (H[1] == " " and key == SpecialApostrophe) {
        savedClip := ClipboardAll()
        A_Clipboard := ""
        SendInput("+{Left 2}^c")
        if ClipWait(0.1) {
            text := A_Clipboard
            SendInput("{Right}")
            if (StrLen(text) >= 1) {
                prevChar := SubStr(text, 1, 1)
                if (IsAlpha(prevChar)) {
                    H[1] := prevChar
                }
            }
        }
        A_Clipboard := savedClip
    }

    ; Versioni lowercase per i confronti
    k1 := StrLower(H[1])
    k2 := StrLower(H[2])
    k3 := StrLower(H[3])
    k4 := StrLower(H[4])

    ; Case check (v1: if H1 is upper)
    ; Se H1 è un SpecialApostrophe o un apostrofo, controlliamo il case del carattere precedente (H2)
    IsLower1 := ((H[1] == SpecialApostrophe or H[1] == "'") ? (H[2] == k2 ? "1" : "0") : (H[1] == k1 ? "1" : "0"))

    ; Alpha checks (v1: if H3 is alpha)
    Alpha2 := (IsAlpha(H[2]) ? "T" : "F")
    Alpha3 := (IsAlpha(H[3]) ? "T" : "F")
    Alpha4 := (IsAlpha(H[4]) ? "T" : "F")
    Alpha5 := (IsAlpha(H[5]) ? "T" : "F")

    NewKey := " "

    ; po'=poco
    if (Alpha3 = "F" and k2 = "p" and k1 = "o" and key = SpecialApostrophe)
        NewKey := "o'"
    else if (Alpha4 = "F" and k3 = "p" and k2 = "o" and k1 = "'" and key = " ")
        NewKey := " "
    else if (Alpha4 = "F" and k3 = "p" and k2 = "o" and k1 = "'" and key = SpecialApostrophe)
        NewKey := "o"

    ; mo'=modo
    else if (Alpha3 = "F" and k2 = "m" and k1 = "o" and key = SpecialApostrophe)
        NewKey := "o'"
    else if (Alpha4 = "F" and k3 = "m" and k2 = "o" and k1 = "'" and key = " ")
        NewKey := " "
    else if (Alpha4 = "F" and k3 = "m" and k2 = "o" and k1 = "'" and key = SpecialApostrophe)
        NewKey := "o"
    else if (Alpha4 = "F" and k3 = "g" and k2 = "i" and k1 = "a" and key = " ") {
        NewKey := "à "
        ToolTip('"già" si scrive sempre con l`accento')
        SetTimer () => ToolTip(), -4000
    }
    else if (Alpha4 = "F" and k3 = "g" and k2 = "i" and k1 = "u" and key = " ") {
        NewKey := "ù "
        ToolTip('"giù" si scrive sempre con l`accento')
        SetTimer () => ToolTip(), -4000
    }
    else if (Alpha4 = "F" and k3 = "p" and k2 = "i" and k1 = "u" and key = " ") {
        NewKey := "ù "
        ToolTip('"più" si scrive sempre con l`accento')
        SetTimer () => ToolTip(), -4000
    }
    else if (Alpha4 = "F" and k3 = "c" and k2 = "i" and k1 = "o" and key = " ") {
        NewKey := "ò "
        ToolTip('"ciò" si scrive sempre con l`accento')
        SetTimer () => ToolTip(), -4000
    }

    ; "blu" senza accento
    else if (Alpha4 = "F" and k3 = "b" and k2 = "l" and k1 = "u" and key = SpecialApostrophe) {
        NewKey := "u"
        ToolTip('"blu" ' . NotaMonosillabi)
        SetTimer () => ToolTip(), -4000
    }
    else if (Alpha3 = "F" and k2 = "b" and k1 = "l" and key = "ù") {
        NewKey := "lu"
        ToolTip('"blu" ' . NotaMonosillabi)
        SetTimer () => ToolTip(), -4000
    }

    ; "Che" Si scrive sempre senza accento (che), tranne quando è usato come troncamento di "perché" (ché).

    ; "qua" o "qui" senza accento
    else if (Alpha4 = "F" and k3 = "q" and k2 = "u" and (k1 = "a" or k1 = "i") and key = SpecialApostrophe) {
        NewKey := k1
        ToolTip('"qua" e "qui" ' . NotaMonosillabi)
        SetTimer () => ToolTip(), -4000
    }
    else if (Alpha3 = "F" and k2 = "q" and k1 = "u" and (key = "à" or key = "ì")) {
        NewKey := "u" . (key = "à" ? "a" : "i")
        ToolTip('"qua" e "qui" ' . NotaMonosillabi)
        SetTimer () => ToolTip(), -4000
    }
    ; "tre" senza accento
    else if (Alpha4 = "F" and k3 = "t" and k2 = "r" and k1 = "e" and key = SpecialApostrophe) {
        NewKey := "e"
        ToolTip('"tre" ' . NotaMonosillabi)
        SetTimer () => ToolTip(), -4000
    }
    else if (Alpha3 = "F" and k2 = "t" and k1 = "r" and (key = "è" or key = "é")) {
        NewKey := "re"
        ToolTip('"tre" ' . NotaMonosillabi)
        SetTimer () => ToolTip(), -4000
    }
    ; "sto" senza accento
    else if (Alpha4 = "F" and k3 = "t" and k2 = "r" and k1 = "o" and key = SpecialApostrophe) {
        NewKey := "o"
        ToolTip('"sto" ' . NotaMonosillabi)
        SetTimer () => ToolTip(), -4000
    }
    else if (Alpha3 = "F" and k2 = "s" and k1 = "t" and key = "ò") {
        NewKey := "to"
        ToolTip('"sto" ' . NotaMonosillabi)
        SetTimer () => ToolTip(), -4000
    }
    ; "sta" senza accento ma con apostrofo nell'imperativo sta'=stai
    else if (Alpha4 = "F" and k3 = "s" and k2 = "t" and k1 = "a" and key = SpecialApostrophe) {
        NewKey := "a'"
        ToolTip('"sta" ' . NotaImperativi)
        SetTimer () => ToolTip(), -4000
    }
    else if (Alpha5 = "F" and k4 = "s" and k3 = "t" and k2 = "a" and k1 = "'" and key = " ")
        NewKey := " "
    else if (Alpha5 = "F" and k4 = "s" and k3 = "t" and k2 = "a" and k1 = "'" and key = SpecialApostrophe)
        NewKey := "a"
    ; "qual" senza apostrofo
    else if (Alpha5 = "F" and k4 = "q" and k3 = "u" and k2 = "a" and k1 = "l" and key = "'") {
        NewKey := "l "
        ToolTip('"qual" senza apostrofo')
        SetTimer () => ToolTip(), -4000
    }
    ; "qual" senza backtick
    else if (Alpha5 = "F" and k4 = "q" and k3 = "u" and k2 = "a" and k1 = "l" and key = "``") {
        NewKey := "l "
        ToolTip('"qual" senza apostrofo')
        SetTimer () => ToolTip(), -4000
    }
    ; "tal" senza apostrofo
    else if (Alpha4 = "F" and k3 = "t" and k2 = "a" and k1 = "l" and key = "'") {
        NewKey := "l "
        ToolTip('"tal" senza apostrofo')
        SetTimer () => ToolTip(), -4000
    }
    ; "tal" senza backtick
    else if (Alpha4 = "F" and k3 = "t" and k2 = "a" and k1 = "l" and key = "``") {
        NewKey := "l "
        ToolTip('"tal" senza apostrofo')
        SetTimer () => ToolTip(), -4000
    }
    ; "fa" senza accento ma con apostrofo nell'imperativo fa'=fai
    else if (Alpha3 = "F" and k2 = "f" and k1 = "a" and key = SpecialApostrophe) {
        NewKey := "a'"
        ToolTip('"fa" ' . NotaImperativi)
        SetTimer () => ToolTip(), -4000
    }
    else if (Alpha4 = "F" and k3 = "f" and k2 = "a" and k1 = "'" and key = " ")
        NewKey := " "
    else if (Alpha4 = "F" and k3 = "f" and k2 = "a" and k1 = "'" and key = SpecialApostrophe)
        NewKey := "a"
    else if (Alpha2 = "F" and k1 = "f" and key = "à") {
        NewKey := "fa"
        ToolTip('"fa" ' . NotaMonosillabi)
        SetTimer () => ToolTip(), -4000
    }
    ; "va" senza accento ma con apostrofo nell'imperativo va'=vai
    else if (Alpha3 = "F" and k2 = "v" and k1 = "a" and key = SpecialApostrophe) {
        NewKey := "a'"
        ToolTip('"va" ' . NotaImperativi)
        SetTimer () => ToolTip(), -4000
    }
    else if (Alpha4 = "F" and k3 = "v" and k2 = "a" and k1 = "'" and key = " ")
        NewKey := " "
    else if (Alpha4 = "F" and k3 = "v" and k2 = "a" and k1 = "'" and key = SpecialApostrophe)
        NewKey := "a"
    ; "su" senza accento
    else if (Alpha3 = "F" and k2 = "s" and k1 = "u" and key = SpecialApostrophe) {
        NewKey := "u"
        ToolTip('"su" ' . NotaMonosillabi)
        SetTimer () => ToolTip(), -4000
    }
    else if (Alpha2 = "F" and k1 = "s" and key = "ù") {
        NewKey := "su"
        ToolTip('"su" ' . NotaMonosillabi)
        SetTimer () => ToolTip(), -4000
    }
    ; "fu" senza accento
    else if (Alpha3 = "F" and k2 = "f" and k1 = "u" and key = SpecialApostrophe) {
        NewKey := "u"
        ToolTip('"fu" ' . NotaMonosillabi)
        SetTimer () => ToolTip(), -4000
    }
    else if (Alpha2 = "F" and k1 = "f" and key = "ù") {
        NewKey := "fu"
        ToolTip('"fu" ' . NotaMonosillabi)
        SetTimer () => ToolTip(), -4000
    }
    ; "sa" senza accento
    else if (Alpha3 = "F" and k2 = "s" and k1 = "a" and key = SpecialApostrophe) {
        NewKey := "a"
        ToolTip('"sa" ' . NotaMonosillabi)
        SetTimer () => ToolTip(), -4000
    }
    else if (Alpha2 = "F" and k1 = "s" and key = "à") {
        NewKey := "sa"
        ToolTip('"sa" ' . NotaMonosillabi)
        SetTimer () => ToolTip(), -4000
    }
    ; "so" senza accento
    else if (Alpha3 = "F" and k2 = "s" and k1 = "o" and key = SpecialApostrophe) {
        NewKey := "o"
        ToolTip('"so" ' . NotaMonosillabi)
        SetTimer () => ToolTip(), -4000
    }
    else if (Alpha2 = "F" and k1 = "s" and key = "ò") {
        NewKey := "so"
        ToolTip('"so" ' . NotaMonosillabi)
        SetTimer () => ToolTip(), -4000
    }
    ; "do" senza accento
    else if (Alpha3 = "F" and k2 = "d" and k1 = "o" and key = SpecialApostrophe) {
        NewKey := "o"
        ToolTip('"do" ' . NotaMonosillabi)
        SetTimer () => ToolTip(), -4000
    }
    else if (Alpha2 = "F" and k1 = "d" and key = "ò") {
        NewKey := "do"
        ToolTip('"do" ' . NotaMonosillabi)
        SetTimer () => ToolTip(), -4000
    }
    ; "re" senza accento
    else if (Alpha3 = "F" and k2 = "r" and k1 = "e" and key = SpecialApostrophe) {
        NewKey := "e"
        ToolTip('"re" ' . NotaMonosillabi)
        SetTimer () => ToolTip(), -4000
    }
    else if (Alpha2 = "F" and k1 = "r" and (key = "è" or key = "é")) {
        NewKey := "re"
        ToolTip('"re" ' . NotaMonosillabi)
        SetTimer () => ToolTip(), -4000
    }

    ;-- Accenti gravi sulla à
    else if (k1 = "a" and key = SpecialApostrophe)
        NewKey := "à"
    else if (k1 = "à" and key = SpecialApostrophe)
        NewKey := "a"

    ;-- Accenti acuti sulla ...hé
    else if (k2 = "h" and k1 = "e" and key = SpecialApostrophe)
        NewKey := "é"
    else if (k2 = "h" and k1 = "é" and key = SpecialApostrophe)
        NewKey := "e"
    ;-- Accenti acuti sulla r é
    else if (k2 = "r" and k1 = "e" and key = SpecialApostrophe)
        NewKey := "é"
    else if (k2 = "r" and k1 = "é" and key = SpecialApostrophe)
        NewKey := "e"

    ;-- ne e né
    else if (Alpha3 = "F" and k2 = "n" and k1 = "e" and key = SpecialApostrophe)
        NewKey := "é"
    else if (Alpha3 = "F" and k2 = "n" and k1 = "é" and key = SpecialApostrophe)
        NewKey := "e"
    ;-- se e sé
    else if (Alpha3 = "F" and k2 = "s" and k1 = "e" and key = SpecialApostrophe)
        NewKey := "é"
    else if (Alpha3 = "F" and k2 = "s" and k1 = "é" and key = SpecialApostrophe)
        NewKey := "e"

    ; Cicla gli accenti sulla e
    else if (k1 = "e" and key = SpecialApostrophe)
        NewKey := "è"
    else if (k1 = "è" and key = SpecialApostrophe)
        NewKey := "é"
    else if (k1 = "é" and key = SpecialApostrophe)
        NewKey := "e"

    ; Cicla gli accenti sulla i (solo grave ì)
    else if (k1 = "i" and key = SpecialApostrophe)
        NewKey := "ì"
    else if (k1 = "ì" and key = SpecialApostrophe)
        NewKey := "i"

    ; Cicla gli accenti sulla do (ad es. andò)
    else if (k2 = "d" and k1 = "o" and key = SpecialApostrophe)
        NewKey := "ò"
    else if (k2 = "d" and k1 = "ò" and key = SpecialApostrophe)
        NewKey := "o"

    ; Cicla gli accenti sulla ro (ad es. però)
    else if (k2 = "r" and k1 = "o" and key = SpecialApostrophe)
        NewKey := "ò"
    else if (k2 = "r" and k1 = "ò" and key = SpecialApostrophe)
        NewKey := "o"

    ; Cicla gli accenti sulla uo (ad es. può)
    else if (k2 = "u" and k1 = "o" and key = SpecialApostrophe)
        NewKey := "ò"
    else if (k2 = "u" and k1 = "ò" and key = SpecialApostrophe)
        NewKey := "o"

    ; Cicla gli accenti sulla o
    else if (k1 = "o" and key = SpecialApostrophe)
        NewKey := "ò"
    else if (k1 = "ò" and key = SpecialApostrophe)
        NewKey := "ó"
    else if (k1 = "ó" and key = SpecialApostrophe)
        NewKey := "o"

    ; Cicla gli accenti sulla u (solo grave ù)
    else if (k1 = "u" and key = SpecialApostrophe)
        NewKey := "ù"
    else if (k1 = "ù" and key = SpecialApostrophe)
        NewKey := "u"

    if (IsLower1 = "0")
        NewKey := StrUpper(NewKey)

    if (NewKey != " ") {
        if (H[1] = SpecialApostrophe or H[1] = "'") {
            SendInput("{Backspace}")
            H.RemoveAt(1)
            H.Push(" ")
        }
        H[1] := SubStr(NewKey, 1, 1)

        if (StrLen(NewKey) > 1)
            ShiftHistory(SubStr(NewKey, 2, 1))

        SendInput("{Backspace 2}" . NewKey)
    } else {
        ShiftHistory(key)
    }
}

; Gestione tasti di movimento e cancellazione
~*Backspace:: {
    ToolTip()
    BackShiftHistory()
}

~*Home::
~*End::
~*Delete::
~*PgUp::
~*PgDn::
~*Up::
~*Down::
~*Left::
~*Right:: {
    ToolTip()
    global H
    H := [" ", " ", " ", " ", " ", " ", " ", " ", " "]
}

BackShiftHistory() {
    global H
    H.RemoveAt(1)
    H.Push(" ")
}

; Abbreviazioni (Hotstrings)
::(c)::©
::(r)::®
::+/-::±
::n_o::n°

; Tasti Scelta Rapida per caratteri speciali (Right Alt)
>!a:: SendSpecialChar("ä")
>!o:: SendSpecialChar("ö")
>!u:: SendSpecialChar("ü")
>!s:: SendSpecialChar("ß")
+>!a:: SendSpecialChar("Ä")
+>!o:: SendSpecialChar("Ö")
+>!u:: SendSpecialChar("Ü")

SendSpecialChar(char) {
    SendText(char)
    ShiftHistory(char)
}

; Inversione tasti Win e Alt per tastiere Apple (parametro 'apple')
#HotIf AppleKeyboard
*LAlt::LWin
*LWin::LAlt
*RAlt::RWin
*RWin::RAlt
#HotIf