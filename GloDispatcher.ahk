#SingleInstance force

lista_termbaz = termbaza2,termbaza3,termbaza4,termbaza5,termbaza6,termbaza7,termbaza8,termbaza9

;wiersz_obrobiony := "Termin Definicja Znaczenie Komentarz Inne Takie"
wiersz_obrobiony := 

;dump_file := "AA-BB-CC nieprawdziwa nazwa dumpa.csv"
;dump_file := "EN-FR-DE nieprawdziwa nazwa dumpa.csv"
dump_file := "EN-PL Pr�bny dump.csv"
if not FileExist(dump_file) ; sprawdzenie, czy plik �r�d�owy dumpa istnieje
	{
	MsgBox Nie znaleziono pliku %dump_file%.`nPodaj prawid�owy plik.
	return
	}

dump_lang_prefix := StrSplit(dump_file, " ")[1]
if not RegExMatch(dump_lang_prefix, "^[A-Z]{2}-[A-Z]{2}") ; sprawdzenie kod�w j�zyk�w istniej�cego pliku dump.
	{
	MsgBox `"%dump_lang_prefix%`" nie zawiera prawid�owych kod�w j�zyk�w.
	return
	}
else
	MsgBox Znaleziono formalnie prawid�owe kody j�zyk�w %dump_lang_prefix%.

langs := StrSplit(dump_lang_prefix, "-")
LangsUniq := []
for l in langs
	{
	if langs[l] = "EN"
		LangsUniq.Push("English")
	if langs[l] = "DE"
		LangsUniq.Push("German")
	if langs[l] = "PL"
		LangsUniq.Push("Polish")
	if langs[l] = "FR"
		LangsUniq.Push("French")
	}
if LangsUniq.Length() < 2
	MsgBox W kodzie %dump_lang_prefix% nie rozpoznano wystarczaj�cej liczby j�zyk�w.`nWybierz inny plik albo sprawd� ustawienia.
else
	MsgBox % "W kodzie " dump_lang_prefix " rozpoznano nast�puj�ce j�zyki:`n" LangsUniq[1] "`n" LangsUniq[2] "`n" LangsUniq[3] "`n" LangsUniq[4]
	
;==powy�szy kod (czytanie j�zyka) zamieni� na funkcj� i przej�� dalej. Najlepiej zamieni� na krotki {EN,English}, czy jako� tak, do obs�ugi dowolnych kod�w j�zykowych (mo�liwe, �e poni�szy FileReadLine nie b�dzie potrzebny -- albo nie w tej postaci;))

;language_pair_regex := "^English$|^Polish$"
FileReadLine, line_one, %dump_file%, 1
;MsgBox % "Nag��wek: " line_one
headings := StrSplit(line_one, ",")
ColHeadingsL := []
ColHeadingsR := []
ColNumsL := []
ColNumsR := []
LeftCount := 0
RightCount := 0
for c in headings
	{
	if headings[c] = LangsUniq[1]
		{
		ColNumsL.Push(c)
		ColHeadingsL.Push(headings[c])
		LeftCount += 1
		}
	}
for c in headings
	{
	if headings[c] = LangsUniq[2]
		{
		ColNumsR.Push(c)
		ColHeadingsR.Push(headings[c])
		RightCount += 1
		}
	}	
for c in headings
	{
	if headings[c] = "Entry_Note"
		entry_note_column_no = % c
	}
	
;ArrToStr(ColHeadingsL)
;ArrToStr(ColNumsL)
;ArrToStr(ColHeadingsR)
;ArrToStr(ColNumsR)


LeftLanguage := LangsUniq[1]
RightLanguage := LangsUniq[2]

;MsgBox %line_one%
Loop, Read, %dump_file% ;do zliczenia linii do nag��wka (i nie tylko)
	{
	total_lines = % A_Index-1
	}
line_count := 1
FileReadLine, line, %dump_file%, % line_count+1
MsgBox % "Linia numer " line_count+1 " pliku " dump_file " wygl�da tak:`n" line

column_index = 1
line_array := StrSplit(line, ",")
term1L = % line_array[ColNumsL[1]]
term2L = % line_array[ColNumsL[2]]
term3L = % line_array[ColNumsL[3]]
term1R = % line_array[ColNumsR[1]]
term2R = % line_array[ColNumsR[2]]
term3R = % line_array[ColNumsR[3]]

term_info1L = % line_array[ColNumsL[1]+1]
term_info2L = % line_array[ColNumsL[2]+1]
term_info3L = % line_array[ColNumsL[3]+1]
term_info1R = % line_array[ColNumsR[1]+1]
term_info2R = % line_array[ColNumsR[2]+1]
term_info3R = % line_array[ColNumsR[3]+1]

NoteContent = % line_array[entry_note_column_no]

FileRead, dump_content, %dump_file%
Loop, parse, dump_content, `n
	{
	wiersz_obrobiony := A_LoopField
	}

; sprawdzenie wra�liwo�ci terminu na wielko�� liter
Case_Radio_Check(term_info1L, "1L")
Case_Radio_Check(term_info2L, "2L")
Case_Radio_Check(term_info3L, "3L")
Case_Radio_Check(term_info1R, "1R")
Case_Radio_Check(term_info2R, "2R")
Case_Radio_Check(term_info3R, "3R")
	
;1. definicja interfejsu graficznego
field_len := 150 ;d�ugo�� pola, w kt�rym wpisany jest termin

Gui, New,, Kopciuszek termin�w
Gui, 1:Add, GroupBox, x10 y20 w300 h140 , %LeftLanguage%
Gui, 1:Add, Text, x190 y40 w100 h20 , Wielko�� liter:
Gui, 1:Add, Edit, x20 y60 w%field_len% h20 vLeftLanguage1, %term1L%
Gui, 1:Add, Radio, x180 y60 w40 h20 %Sens1L% vCaseSens1L, +
Gui, 1:Add, Radio, x220 y60 w40 h20 %Perm1L%, /
Gui, 1:Add, Radio, x260 y60 w40 h20 %Ins1L%, -
Gui, 1:Add, Edit, x20 y90 w%field_len% h20 vLeftLanguage2, %term2L%
Gui, 1:Add, Radio, x180 y90 w40 h20 %Sens2L% vCaseSens2L, +
Gui, 1:Add, Radio, x220 y90 w40 h20 %Perm2L%, /
Gui, 1:Add, Radio, x260 y90 w40 h20 %Ins2L%, -
Gui, 1:Add, Edit, x20 y120 w%field_len% h20 vLeftLanguage3, %term3L%
Gui, 1:Add, Radio, x180 y120 w40 h20 %Sens3L% vCaseSens3L, +
Gui, 1:Add, Radio, x220 y120 w40 h20 %Perm3L%, /
Gui, 1:Add, Radio, x260 y120 w40 h20 %Ins3L%, -
Gui, 1:Add, GroupBox, x340 y20 w300 h140 , %RightLanguage%
Gui, 1:Add, Text, x520 y40 w100 h20 , Wielko�� liter:
Gui, 1:Add, Edit, x350 y60 w%field_len% h20 vRightLanguage1, %term1R%
Gui, 1:Add, Radio, x510 y60 w40 h20 %Sens1R% vCaseSens1R, +
Gui, 1:Add, Radio, x550 y60 w40 h20 %Perm1R%, /
Gui, 1:Add, Radio, x590 y60 w40 h20 %Ins1R%, -
Gui, 1:Add, Edit, x350 y90 w%field_len% h20 vRightLanguage2, %term2R%
Gui, 1:Add, Radio, x510 y90 w40 h20 %Sens2R% vCaseSens2R, +
Gui, 1:Add, Radio, x550 y90 w40 h20 %Perm2R%, /
Gui, 1:Add, Radio, x590 y90 w40 h20 %Ins2R%, -
Gui, 1:Add, Edit, x350 y120 w%field_len% h20 vRightLanguage3, %term3R%
Gui, 1:Add, Radio, x510 y120 w40 h20 %Sens3R% vCaseSens3R, +
Gui, 1:Add, Radio, x550 y120 w40 h20 %Perm3R%, /
Gui, 1:Add, Radio, x590 y120 w40 h20 %Ins3R%, -
Gui, 1:Add, Text, x40 y170, Note:
Gui, 1:Add, Edit, x30 y190 w590 h60 vEntryNote, %NoteContent%

a = 1
Gui, 1:Add, Button, gPrzycisk%a% x10, termbaza1
Loop, parse, lista_termbaz, `,
	{
	a += 1
	Przycisk := A_LoopField
	Gui, 1:Add, Button, gPrzycisk%a% x+10, %Przycisk%
	}
; Generated using SmartGUI Creator 4.0
Gui, 1:Show,, Kopciuszek - Termin %line_count% z %total_lines%
Return

1GuiClose:
ExitApp






Przycisk1:
^1::
Gui, Destroy
ExitApp

Przycisk2:
^2::
return

Przycisk3:
^3::
return

Przycisk4:
^4::
return

Przycisk5:
^5::
return

Przycisk6:
^6::
return

Przycisk7:
^7::
return

Przycisk8:
^8::
return

Przycisk9:
^9::
return


GuiClose:
GuiEscape:
Gui, Destroy
ExitApp


;==========================================================================
;==========================================================================
;==========================================================================
;=============================== lista p�ac ===============================
;==========================================================================
;==========================================================================
;==========================================================================

;=== funkcja, kt�ra czyta parametr Case Sensitivity terminu i powoduje zaznaczenie przycisku radio przy odpowiednim terminie
Case_Radio_Check(Term_Info, item_ordin)
{
	if InStr(Term_Info, "CaseSense")
		return Sens%item_ordin% := "Checked"
	if InStr(Term_Info, "CasePermissive")
		return Perm%item_ordin% := "Checked"
	if InStr(Term_Info, "CaseInsense")
		return Ins%item_ordin% := "Checked"
}

;=== funkcja do odczytu nag��wk�w kolumn
GetColumnHeadings(sourcefile)
{
;global debug
FileReadLine, line_one, %sourcefile%, 1
headings := StrSplit(line_one, ";")
Debugger("Nag��wek: " line_one)
ColHeadings := []
for c in headings
	{
	if InStr(headings[c], "English")
		ColHeadings.Push(c)
	if InStr(headings[c], "German")
		ColHeadings.Push(c)
	if InStr(headings[c], "Polish")
		ColHeadings.Push(c)
	}
if ColHeadings.Length() > 0
	{
	Debugger("Tablica z kolumnami ma " ColHeadings.Length() " elementy d�ugo�ci.")
	return ColHeadings
	}
else
	{
	Debugger("Wysz�o zero element�w, czyli nag��wki si� nie zgadzaj�.")
	return False
	}
}
	




;=========== funkcja do tworzenia listy z tre�ci tablicy (zwykle do MsgBox i innych form sprawdzenia) ======
ArrToStr(array, delim:="`n")
{
	listarr := ;zmienna tekstowa odpowiadaj�ca tre�ci tablicy w ramach tej funkcji (tylko do wy�wietlania w MsgBox)
	For i in array
		listarr .= array[i]delim
	
	if array.Length() = 0
		MsgBox,, ArrToStr, % "Wygl�da, �e ta tablica jest pusta:("
	else
		MsgBox,, ArrToStr, % "Z zadanej listy pasuje tyle element�w: " array.Length()"`n`nA s� to nast�puj�ce elementy:`n`n"RTrim(listarr, delim)
return RTrim(listarr, delim)
}



;=== funkcja do odrobaczania
Debugger(message_content, time:="standard")	
{
global debug
if debug != False
	{
	if time = standard
		MsgBox,,, %message_content%, %debug%
	else
		MsgBox,,, %message_content%, %time%
	}
}
