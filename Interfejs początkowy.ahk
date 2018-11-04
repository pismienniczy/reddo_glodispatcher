Gui, 1:Add, Edit, x22 y69 w150 h20 , LeftLanguage1
Gui, 1:Add, Edit, x22 y99 w150 h20 , LeftLanguage2
Gui, 1:Add, Edit, x22 y129 w150 h20 , LeftLanguage3
Gui, 1:Add, GroupBox, x342 y19 w300 h140 , %RightLanguage%
Gui, 1:Add, Edit, x352 y69 w150 h20 , RightLanguage1
Gui, 1:Add, Edit, x352 y99 w150 h20 , RightLanguage2
Gui, 1:Add, Edit, x352 y129 w150 h20 , RightLanguage3
Gui, 1:Add, GroupBox, x12 y19 w300 h140 , %LeftLanguage%
Gui, 1:Add, Radio, x182 y69 w40 h20 , +
Gui, 1:Add, Radio, x222 y69 w40 h20 , /
Gui, 1:Add, Radio, x262 y69 w40 h20 , -
Gui, 1:Add, Radio, x222 y99 w40 h20 , /
Gui, 1:Add, Radio, x262 y99 w40 h20 , -
Gui, 1:Add, Radio, x182 y129 w40 h20 , +
Gui, 1:Add, Radio, x222 y129 w40 h20 , /
Gui, 1:Add, Radio, x262 y129 w40 h20 , -
Gui, 1:Add, Text, x192 y39 w100 h20 , Wielkoœæ liter:
Gui, 1:Add, Radio, x182 y99 w40 h20 , +
Gui, 1:Add, Radio, x592 y69 w40 h20 , -
Gui, 1:Add, Radio, x552 y69 w40 h20 , /
Gui, 1:Add, Radio, x512 y69 w40 h20 , +
Gui, 1:Add, Radio, x512 y99 w40 h20 , +
Gui, 1:Add, Radio, x552 y99 w40 h20 , /
Gui, 1:Add, Radio, x592 y99 w40 h20 , -
Gui, 1:Add, Radio, x512 y129 w40 h20 , +
Gui, 1:Add, Radio, x552 y129 w40 h20 , /
Gui, 1:Add, Radio, x592 y129 w40 h20 , -
Gui, 1:Add, Text, x522 y39 w100 h20 , Wielkoœæ liter:
Gui, 1:Add, Edit, x32 y169 w590 h60 , NoteContent
; Generated using SmartGUI Creator 4.0
Gui, 1:Show,, New GUI Window
Return

1GuiClose:
ExitApp