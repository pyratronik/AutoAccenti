; Abbreviazioni (Hotstrings)
::(c)::©
::(r)::®
::+/-::±
::n_o::n°

; Tasti Scelta Rapida per caratteri speciali (Right Alt)
#HotIf GermanKeyboard
>!a:: SendSpecialChar("ä")
>!o:: SendSpecialChar("ö")
>!u:: SendSpecialChar("ü")
>!s:: SendSpecialChar("ß")
+>!a:: SendSpecialChar("Ä")
+>!o:: SendSpecialChar("Ö")
+>!u:: SendSpecialChar("Ü")
#HotIf

; Date shortcuts
:*:``dt``::
{
    SendInput(FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss"))
    return
}
:*:``ts``::
{
    SendInput(FormatTime(A_Now, "yyyy-MM-dd_HHmmss"))
    return
}

:*:``date``::
{
    SendInput(FormatTime(A_Now, "dd MMM yyyy"))
    return
}

:*:``time``::
{
    SendInput(FormatTime(A_Now, "HH:mm:ss"))
    return
}
