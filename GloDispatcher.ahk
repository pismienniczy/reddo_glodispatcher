#SingleInstance force
SetWorkingDir %A_ScriptDir% ;do wywo�ywania skryptu innymi narz�dziami (inaczej plik .ini powstaje, gdzie popadnie)

;### doko�czy� zapisywanie danych do pliku .ini i wczytywanie z niego na bie��co
;### [ten problem istnia�, gdy MolochInterfejs by� osobn� funkcj�; sprawdzi�, czy po wypleceniu z funkcji problem nadal wyst�puje (nie powinien)] zamkni�cie InputBoxa klawiszem Esc wywo�uje b��d; przycisk Cancel go nie wywo�uje; zamieni� InputBox na Gui? - Nie zamienia�. Jest tylko gorzej...

;lista_termbaz_pocz�tkowa := ("termbaza2,termbaza3,termbaza4,termbaza5,termbaza6,termbaza7,termbaza8,termbaza9")
inicontent := ("###plik konfiguracyjny narz�dzia " A_ScriptName "###`nAutor: Piotr Wielecki`nWersja: wrzesie� 2019 r.`nWy��czno�� u�ytkowania: REDDO Translations`n`n[DumpFileName]`ndump_file=EN-PL Pr�bny dump.csv`n[ButtonNames]`npierwsza_termbaza=termbaza01`nlista_termbaz_pocz�tkowa=termbaza02,termbaza03,termbaza04,termbaza05,termbaza06,termbaza07,termbaza08,termbaza09`n`n[TermbaseFileNames]`nnazwy_termbaz_docelowych=`n`n###koniec pliku###")

; zmienne przechowuj�ce termbazy dla przycisk�w -- tu puste, bo chodzi tylko o ich utworzenie na pocz�tku wszystkiego
ButtonTermbase1 :=
ButtonTermbase2 :=
ButtonTermbase3 :=
ButtonTermbase4 :=
ButtonTermbase5 :=
ButtonTermbase6 :=
ButtonTermbase7 :=
ButtonTermbase8 :=
ButtonTermbase9 :=

StringTrimRight, filename, A_ScriptName, 4
; ### pierwsze okno do tworzenia nowego dumpa -- modu� 0.0
if FileExist(filename ".ini")
	IniRead, plik_dumpa_z_ini, % filename ".ini", DumpFileName, dump_file
	IniRead, pierwsza_termbaza, % filename ".ini", ButtonNames, pierwsza_termbaza
	IniRead, lista_termbaz_pocz�tkowa, % filename ".ini", ButtonNames, lista_termbaz_pocz�tkowa
	IniRead, nazwy_termbaz_docelowych, % filename ".ini", TermbaseFileNames, nazwy_termbaz_docelowych
	
if not StrLen(nazwy_termbaz_docelowych) = 0
	{
;	MsgBox oto nazwy termbaz ##%nazwy_termbaz_docelowych%##
	diplay_tb_list := StrReplace(nazwy_termbaz_docelowych, ",", "`n")
	}
	
if dump_file := ""
;	{
	Gui, 1:New, %filename% � rozpoczynanie pracy z Kopciuszkiem
	Gui, 1:Add, Text,, Plik dumpa, kt�ry zamierzasz obrabia�:
	Gui, 1:Add, Edit, r1 w400 vdump_file, %plik_dumpa_z_ini%
	if StrLen(nazwy_termbaz_docelowych) = 0
		{
	;	MsgBox puste ##%nazwy_termbaz_docelowych%##
		Gui, Add, Text,, [Brak termbaz docelowych. Wybierzesz je p�niej za pomoc� przycisk�w segregacji.]
		}
	else
		{
	;	MsgBox niepuste ##%nazwy_termbaz_docelowych%##
		Gui, 1:Add, Text,, Do obr�bki tego dumpa u�ywano ostatnio nast�puj�cych termbaz:`n%diplay_tb_list%
		}
	Gui, 1:Add, Button, w100 x80 default, Kontynuuj
	Gui, 1:Add, Button, vStop w100 x+60, Anuluj
	Gui, 1:Show
	return

	ButtonAnuluj:
	GuiClose(1):
	GuiEscape(1):
	Gui, 1:Destroy
	ExitApp

	ButtonKontynuuj:
	Gui, 1:Submit, HoHide
;	}

; ### pierwsze okno do tworzenia nowego dumpa -- koniec modu�u 0.0

;wiersz_obrobiony := "Termin Definicja Znaczenie Komentarz Inne Takie"
wiersz_obrobiony := 
dump_target_path :=

if not FileExist(dump_file) ; sprawdzenie, czy plik �r�d�owy dumpa istnieje
	{
	MsgBox Nie znaleziono pliku %dump_file%.`nPodaj prawid�owy plik.
	return
	}
if InStr(dump_file, "\")
	{
	dump_file_name := StrSplit(dump_file, "\")[StrSplit(dump_file, "\").Length()]
	
	SplitPath, dump_file,, dump_target_path
	dump_target_path = % dump_target_path "\"
	
;	MsgBox dump_target_path to %dump_target_path%
;	MsgBox nazwa ca�ej �cie�ki %dump_file%`nnazwa pliczku %dump_file_name%
	}
else
	{
	dump_file_name := dump_file
	dump_target_path = A_WorkingDir "\"
	}
dump_lang_prefix := SubStr(dump_file_name, 1, 5)
if not RegExMatch(dump_lang_prefix, "^[A-Z]{2}-[A-Z]{2}") ; sprawdzenie kod�w j�zyk�w istniej�cego pliku dump.
	{
	MsgBox `"%dump_lang_prefix%`" nie zawiera prawid�owych kod�w j�zyk�w.
	return
	}
else
;	MsgBox Znaleziono formalnie prawid�owe kody j�zyk�w %dump_lang_prefix%.
IniWrite, dump_file=%dump_file%, % filename ".ini", DumpFileName
Gui, 1:Destroy

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
	{
	MsgBox W kodzie %dump_lang_prefix% nie rozpoznano wystarczaj�cej liczby j�zyk�w.`nWybierz inny plik albo sprawd� ustawienia.
	return
	}
else
;	MsgBox % "W kodzie " dump_lang_prefix " rozpoznano nast�puj�ce j�zyki:`n" LangsUniq[1] "`n" LangsUniq[2] "`n" LangsUniq[3] "`n" LangsUniq[4]
	
;==powy�szy kod (czytanie j�zyka) zamieni� na funkcj�. Najlepiej zamieni� na krotki {EN,English}, czy jako� tak, do obs�ugi dowolnych kod�w j�zykowych.

;language_pair_regex := "^English$|^Polish$"
FileReadLine, line_one, %dump_file%, 1
;MsgBox % "Nag��wek: " line_one
if InStr(line_one, ";")
	{
	MsgBox, 48, Napotkano genera�!, Nieprawid�owy separator pliku.`nWykryto �rednik`, za� program obrabia tylko pliki CSV rozdzielane przecinkiem.`nZmie� separator pliku w innym programie i pon�w pr�b�.
	ExitApp
	}
headings := []
Loop, Parse, line_one, CSV
	{
	headings.Push(A_LoopField)
	} 

	
;headings := StrSplit(line_one, ",")
ColHeadingsL := []
ColHeadingsR := []
ColNumsL := []
ColNumsR := []
LeftCount := 0
RightCount := 0
for c in headings ; zbiera nag��wki kolumn j�zyka lewego
	{
	if headings[c] = LangsUniq[1]
		{
		ColNumsL.Push(c)
		ColHeadingsL.Push(headings[c])
		LeftCount += 1
		}
	}
for c in headings ; zbiera nag��wki kolumn j�zyka prawego
	{
	if headings[c] = LangsUniq[2]
		{
		ColNumsR.Push(c)
		ColHeadingsR.Push(headings[c])
		RightCount += 1
		}
	}	
for c in headings ; nag��wek pola "Entry Note"
	{
	if headings[c] = "Entry_Note"
		entry_note_column_no = % c
	}
	
;MsgBox % "tablica ColHeadingsL`n" ArrToStr(ColHeadingsL)
;MsgBox % "tablica ColNumsL`n" ArrToStr(ColNumsL)
;MsgBox % "tablica ColHeadingsR`n" ArrToStr(ColHeadingsR)
;MsgBox % "tablica ColNumsR`n" ArrToStr(ColNumsR)


;MsgBox %line_one%
Loop, Read, %dump_file% ;do zliczenia linii do nag��wka (i nie tylko)
	{
	total_lines = % A_Index-1
	}



if not StrLen(nazwy_termbaz_docelowych) = 0
	{
	ButtonNamesArray :=	StrSplit(nazwy_termbaz_docelowych, ",")
	
	for i in ButtonNamesArray
		{
		ButtonTermbase%i% := ButtonNamesArray[1]
		MsgBox % "Przycisk " i " ma warto�� " ButtonNamesArray[i]
		}
	}

lista_termbaz = % lista_termbaz_pocz�tkowa

line_count := 2

;### tu zaczyna si� trzon wielkiego interfejsu

; nag��wki p�l obrysowuj�cych dwie kolumny j�zykowe
LeftLanguage := LangsUniq[1]
RightLanguage := LangsUniq[2]

if WinExist(Kopciuszek)
	Gui, 2:Destroy

FileReadLine, line, %dump_file%, % line_count
;MsgBox % "Linia numer " line_count-1 " pliku " dump_file " wygl�da tak:`n" line

line_array := []

Loop, Parse, line, CSV
	{
	line_array.Push(A_LoopField)
	} 

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

; sprawdzenie wra�liwo�ci terminu na wielko�� liter (nie uda�o si� tego opakowa� w funkcj� :v)
;Case_Radio_Check(term_info1L, "1L")
if InStr(term_info1L, "CaseSense")
	Sens1L := "Checked"
if InStr(term_info1L, "CasePermissive")
	Perm1L := "Checked"
if InStr(term_info1L, "CaseInsense")
	Ins1L := "Checked"
;Case_Radio_Check(term_info2L, "2L")
if InStr(term_info2L, "CaseSense")
	Sens2L := "Checked"
if InStr(term_info2L, "CasePermissive")
	Perm2L := "Checked"
if InStr(term_info2L, "CaseInsense")
	Ins2L := "Checked"
;Case_Radio_Check(term_info3L, "3L")
if InStr(term_info3L, "CaseSense")
	Sens3L := "Checked"
if InStr(term_info3L, "CasePermissive")
	Perm3L := "Checked"
if InStr(term_info3L, "CaseInsense")
	Ins3L := "Checked"
;Case_Radio_Check(term_info1R, "1R")
if InStr(term_info1R, "CaseSense")
	Sens1R := "Checked"
if InStr(term_info1R, "CasePermissive")
	Perm1R := "Checked"
if InStr(term_info1R, "CaseInsense")
	Ins1R := "Checked"
;Case_Radio_Check(term_info2R, "2R")
if InStr(term_info2R, "CaseSense")
	Sens2R := "Checked"
if InStr(term_info2R, "CasePermissive")
	Perm2R := "Checked"
if InStr(term_info2R, "CaseInsense")
	Ins2R := "Checked"
;Case_Radio_Check(term_info3R, "3R")
if InStr(term_info3R, "CaseSense")
	Sens3R := "Checked"
if InStr(term_info3R, "CasePermissive")
	Perm3R := "Checked"
if InStr(term_info3R, "CaseInsense")
	Ins3R := "Checked"

field_len := 150 ;d�ugo�� pola, w kt�rym wpisany jest termin

Gui, 2:New,, Kopciuszek termin�w
Gui, 2:Add, GroupBox, x10 y20 w300 h140 , %LeftLanguage%
Gui, 2:Add, Text, x190 y40 w100 h20 , Wielko�� liter:
Gui, 2:Add, Edit, x20 y60 w%field_len% h20 vLeftLanguage1, %term1L%
Gui, 2:Add, Radio, x180 y60 w40 h20 %Sens1L% vCaseSens1L, +
Gui, 2:Add, Radio, x220 y60 w40 h20 %Perm1L%, /
Gui, 2:Add, Radio, x260 y60 w40 h20 %Ins1L%, -
Gui, 2:Add, Edit, x20 y90 w%field_len% h20 vLeftLanguage2, %term2L%
Gui, 2:Add, Radio, x180 y90 w40 h20 %Sens2L% vCaseSens2L, +
Gui, 2:Add, Radio, x220 y90 w40 h20 %Perm2L%, /
Gui, 2:Add, Radio, x260 y90 w40 h20 %Ins2L%, -
Gui, 2:Add, Edit, x20 y120 w%field_len% h20 vLeftLanguage3, %term3L%
Gui, 2:Add, Radio, x180 y120 w40 h20 %Sens3L% vCaseSens3L, +
Gui, 2:Add, Radio, x220 y120 w40 h20 %Perm3L%, /
Gui, 2:Add, Radio, x260 y120 w40 h20 %Ins3L%, -
Gui, 2:Add, GroupBox, x340 y20 w300 h140 , %RightLanguage%
Gui, 2:Add, Text, x520 y40 w100 h20 , Wielko�� liter:
Gui, 2:Add, Edit, x350 y60 w%field_len% h20 vRightLanguage1, %term1R%
Gui, 2:Add, Radio, x510 y60 w40 h20 %Sens1R% vCaseSens1R, +
Gui, 2:Add, Radio, x550 y60 w40 h20 %Perm1R%, /
Gui, 2:Add, Radio, x590 y60 w40 h20 %Ins1R%, -
Gui, 2:Add, Edit, x350 y90 w%field_len% h20 vRightLanguage2, %term2R%
Gui, 2:Add, Radio, x510 y90 w40 h20 %Sens2R% vCaseSens2R, +
Gui, 2:Add, Radio, x550 y90 w40 h20 %Perm2R%, /
Gui, 2:Add, Radio, x590 y90 w40 h20 %Ins2R%, -
Gui, 2:Add, Edit, x350 y120 w%field_len% h20 vRightLanguage3, %term3R%
Gui, 2:Add, Radio, x510 y120 w40 h20 %Sens3R% vCaseSens3R, +
Gui, 2:Add, Radio, x550 y120 w40 h20 %Perm3R%, /
Gui, 2:Add, Radio, x590 y120 w40 h20 %Ins3R%, -
Gui, 2:Add, Text, x40 y170, Note:
Gui, 2:Add, Edit, x30 y190 w590 h60 vEntryNote, %NoteContent%

a = 1
Gui, 2:Add, Button, vPrzycisk%a% gPrzycisk%a% x10, %pierwsza_termbaza%
TB_names_arr := []
Loop, parse, lista_termbaz, `,
	{
	a += 1
	Przycisk := A_LoopField
	Gui, 2:Add, Button, vPrzycisk%a% gPrzycisk%a% x+10, %Przycisk%
	TB_names_arr.Push(A_LoopField)
	}

Gui, 2:Show,, % "Kopciuszek - Termin " line_count-1 " z " total_lines  " (" dump_file_name ")"
Gui, 2:Submit, NoHide
return

;### tu ko�czy si� trzon wielkiego interfejsu

Przycisk1:
^1::
Gui, 2:Destroy
ExitApp

Przycisk2:
^2::
nast�pny := ; s�u�y do przechodzenia do kolejnej linii pliku (albo nie).
;MsgBox plik ButtonTermbase2 nazywa si� %ButtonTermbase2%
termbase_full_file_name = % dump_target_path ButtonTermbase2
StringTrimRight, termbase_full_file_name_no_extension, termbase_full_file_name, 4
;MsgBox pe�na �cie�ka pliku TB to %termbase_full_file_name_no_extension%
if not FileExist(termbase_full_file_name_no_extension ".csv")
	{
	ButtonTermbase2 := Button_Create_Termbase("02")
	if RegExMatch(ButtonTermbase2, "(?<=[A-Z]{2}-[A-Z]{2} ).*(?=\.csv)", nazwa_na_przycisk)
		{
		kr�tka_nazwa_na_przycisk := SubStr(nazwa_na_przycisk, 1, 9)
		old_name = % "termbaza02" 
		lista_termbaz := StrReplace(lista_termbaz, old_name, kr�tka_nazwa_na_przycisk)
		GuiControl,, Przycisk2, %kr�tka_nazwa_na_przycisk%
		}
	else
		{
		
		}
	return
	}
else
	{
;	Gui, 2:Submit, NoHide
	}

MsgBox, 3, % "Termin zostanie zapisany w termbazie " ButtonTermbase2, Czy po zapisaniu chcesz przej�� do kolejnego terminu?`n(Wybranie �Nie� pozwoli na przypisanie tego samego terminu do innej termbazy).
IfMsgBox Cancel
	{
	return
	}
	else
		{
		IfMsgBox Yes
			{
;			Gui, 2:Submit, NoHide
			nast�pny := True
;			MsgBox nast�pny = %nast�pny%
			line_count += 1
		;return
			}
		IfMsgBox No
			{
			nast�pny := False
;			MsgBox nast�pny = %nast�pny%
;			MsgBox czyli nie
;			Gui, 2:Submit, NoHide
		;return
			}
							
;MsgBox % "linia line_array przed obr�bk�`n" ArrToStr(line_array)
Gui, 2:Submit, NoHide
line_to_append_array := line_array
; w tym miejscu tworzymy tablic�, z kt�rej b�dzie generowana nowa linia
;MsgBox % "linia line_to_append_array przed obr�bk�`n" ArrToStr(line_to_append_array)

For i in ColNumsL
	{
ReplaceArrayItem(line_to_append_array, ColNumsL[A_Index], LeftLanguage%A_Index%)
	}

For i in ColNumsR
	{
ReplaceArrayItem(line_to_append_array, ColNumsR[A_Index], RightLanguage%A_Index%)
	}

;poni�szy kawa�ek s�u�y do generowania pola metadanych has�a
CaseValue1L :=
CaseValue2L :=
CaseValue3L :=
CaseValue1R :=
CaseValue2R :=
CaseValue3R :=

Loop 3 ;metadane j�zyka lewego
	{
	if (StrLen(LeftLanguage%A_Index%) != 0) and (InStr(LeftLanguage%A_Index%, "*") or InStr(LeftLanguage%A_Index%, "|"))
		{
		if CaseSens%A_Index%L = 1
			CaseValue%A_Index%L := "CaseSense;Custom"
		if (CaseSens%A_Index%L = 2) or (CaseSens%A_Index%L = 0)
			CaseValue%A_Index%L := "CasePermissive;Custom"
		if CaseSens%A_Index%L = 3
			CaseValue%A_Index%L := "CaseInsense;Custom"
		}
	else
		{
		if CaseSens%A_Index%L = 1
			CaseValue%A_Index%L := "CaseSense;Exact"
		if (CaseSens%A_Index%L = 2) or (CaseSens%A_Index%L = 0)
			CaseValue%A_Index%L := "CasePermissive;Exact"
		if CaseSens%A_Index%L = 3
			CaseValue%A_Index%L := "CaseInsense;Exact"
		}
	}
Loop 3
	{
	if (StrLen(RightLanguage%A_Index%) != 0) and (InStr(RightLanguage%A_Index%, "*") or InStr(RightLanguage%A_Index%, "|"))
		{
		if CaseSens%A_Index%R = 1
			CaseValue%A_Index%R := "CaseSense;Custom"
		if (CaseSens%A_Index%R = 2) or (CaseSens%A_Index%R = 0)
			CaseValue%A_Index%R := "CasePermissive;Custom"
		if CaseSens%A_Index%R = 3
			CaseValue%A_Index%R := "CaseInsense;Custom"
		}
	else
		{
		if CaseSens%A_Index%R = 1
			CaseValue%A_Index%R := "CaseSense;Exact"
		if (CaseSens%A_Index%R = 2) or (CaseSens%A_Index%R = 0)
			CaseValue%A_Index%R := "CasePermissive;Exact"
		if CaseSens%A_Index%R = 3
			CaseValue%A_Index%R := "CaseInsense;Exact"
		}
	}

For i in ColNumsL
	{
ReplaceArrayItem(line_to_append_array, ColNumsL[A_Index]+1, CaseValue%A_Index%L)
	}

For i in ColNumsL
	{
ReplaceArrayItem(line_to_append_array, ColNumsR[A_Index]+1, CaseValue%A_Index%R)
	}

ReplaceArrayItem(line_to_append_array, entry_note_column_no, EntryNote)

line_to_append := ArrToStr(line_to_append_array, "CSV")

FileAppend, %line_to_append%`n, % dump_target_path ButtonTermbase2
		
		} ; koniec opcji yes/no
if WinExist(Kopciuszek)
	Gui, 2:Destroy

;MsgBox ile wynosi nast�pny`n %nast�pny%
if nast�pny = 1
	{
	if (line_count-1 > total_lines)
		{
		MsgBox, 64, Koniec obr�bki, Zako�czono obrabianie dumpa %dump_file%`nZalecane jest kontrolne obejrzenie plik�w docelowych przed ich odes�aniem.
		IniWrite, dump_file=, % filename ".ini", DumpFileName
		Gui, 2:Destroy
		ExitApp
		}
	else
		{
		FileReadLine, line, %dump_file%, % line_count
		}
;		MsgBox wczytuj� kolejn� lini�`nline_count wynosi %line_count%
	}
; MsgBox % "Linia numer " line_count-1 " pliku " dump_file " wygl�da tak:`n" line
if nast�pny = 0
	{
	line := line_to_append
;	MsgBox wczytuj� t� sam� lini�`nline_count wynosi %line_count%
	}
	
line_array := []

Loop, Parse, line, CSV
	{
	line_array.Push(A_LoopField)
	} 

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

; sprawdzenie wra�liwo�ci terminu na wielko�� liter (nie uda�o si� tego opakowa� w funkcj� :v)
;Case_Radio_Check(term_info1L, "1L")
if InStr(term_info1L, "CaseSense")
	Sens1L := "Checked"
if InStr(term_info1L, "CasePermissive")
	Perm1L := "Checked"
if InStr(term_info1L, "CaseInsense")
	Ins1L := "Checked"
;Case_Radio_Check(term_info2L, "2L")
if InStr(term_info2L, "CaseSense")
	Sens2L := "Checked"
if InStr(term_info2L, "CasePermissive")
	Perm2L := "Checked"
if InStr(term_info2L, "CaseInsense")
	Ins2L := "Checked"
;Case_Radio_Check(term_info3L, "3L")
if InStr(term_info3L, "CaseSense")
	Sens3L := "Checked"
if InStr(term_info3L, "CasePermissive")
	Perm3L := "Checked"
if InStr(term_info3L, "CaseInsense")
	Ins3L := "Checked"
;Case_Radio_Check(term_info1R, "1R")
if InStr(term_info1R, "CaseSense")
	Sens1R := "Checked"
if InStr(term_info1R, "CasePermissive")
	Perm1R := "Checked"
if InStr(term_info1R, "CaseInsense")
	Ins1R := "Checked"
;Case_Radio_Check(term_info2R, "2R")
if InStr(term_info2R, "CaseSense")
	Sens2R := "Checked"
if InStr(term_info2R, "CasePermissive")
	Perm2R := "Checked"
if InStr(term_info2R, "CaseInsense")
	Ins2R := "Checked"
;Case_Radio_Check(term_info3R, "3R")
if InStr(term_info3R, "CaseSense")
	Sens3R := "Checked"
if InStr(term_info3R, "CasePermissive")
	Perm3R := "Checked"
if InStr(term_info3R, "CaseInsense")
	Ins3R := "Checked"

field_len := 150 ;d�ugo�� pola, w kt�rym wpisany jest termin

Gui, 2:New,, Kopciuszek termin�w
Gui, 2:Add, GroupBox, x10 y20 w300 h140 , %LeftLanguage%
Gui, 2:Add, Text, x190 y40 w100 h20 , Wielko�� liter:
Gui, 2:Add, Edit, x20 y60 w%field_len% h20 vLeftLanguage1, %term1L%
Gui, 2:Add, Radio, x180 y60 w40 h20 %Sens1L% vCaseSens1L, +
Gui, 2:Add, Radio, x220 y60 w40 h20 %Perm1L%, /
Gui, 2:Add, Radio, x260 y60 w40 h20 %Ins1L%, -
Gui, 2:Add, Edit, x20 y90 w%field_len% h20 vLeftLanguage2, %term2L%
Gui, 2:Add, Radio, x180 y90 w40 h20 %Sens2L% vCaseSens2L, +
Gui, 2:Add, Radio, x220 y90 w40 h20 %Perm2L%, /
Gui, 2:Add, Radio, x260 y90 w40 h20 %Ins2L%, -
Gui, 2:Add, Edit, x20 y120 w%field_len% h20 vLeftLanguage3, %term3L%
Gui, 2:Add, Radio, x180 y120 w40 h20 %Sens3L% vCaseSens3L, +
Gui, 2:Add, Radio, x220 y120 w40 h20 %Perm3L%, /
Gui, 2:Add, Radio, x260 y120 w40 h20 %Ins3L%, -
Gui, 2:Add, GroupBox, x340 y20 w300 h140 , %RightLanguage%
Gui, 2:Add, Text, x520 y40 w100 h20 , Wielko�� liter:
Gui, 2:Add, Edit, x350 y60 w%field_len% h20 vRightLanguage1, %term1R%
Gui, 2:Add, Radio, x510 y60 w40 h20 %Sens1R% vCaseSens1R, +
Gui, 2:Add, Radio, x550 y60 w40 h20 %Perm1R%, /
Gui, 2:Add, Radio, x590 y60 w40 h20 %Ins1R%, -
Gui, 2:Add, Edit, x350 y90 w%field_len% h20 vRightLanguage2, %term2R%
Gui, 2:Add, Radio, x510 y90 w40 h20 %Sens2R% vCaseSens2R, +
Gui, 2:Add, Radio, x550 y90 w40 h20 %Perm2R%, /
Gui, 2:Add, Radio, x590 y90 w40 h20 %Ins2R%, -
Gui, 2:Add, Edit, x350 y120 w%field_len% h20 vRightLanguage3, %term3R%
Gui, 2:Add, Radio, x510 y120 w40 h20 %Sens3R% vCaseSens3R, +
Gui, 2:Add, Radio, x550 y120 w40 h20 %Perm3R%, /
Gui, 2:Add, Radio, x590 y120 w40 h20 %Ins3R%, -
Gui, 2:Add, Text, x40 y170, Note:
Gui, 2:Add, Edit, x30 y190 w590 h60 vEntryNote, %NoteContent%

a = 1
Gui, 2:Add, Button, vPrzycisk%a% gPrzycisk%a% x10, %pierwsza_termbaza%
TB_names_arr := []
Loop, parse, lista_termbaz, `,
	{
	a += 1
	Przycisk := A_LoopField
	Gui, 2:Add, Button, vPrzycisk%a% gPrzycisk%a% x+10, %Przycisk%
	TB_names_arr.Push(A_LoopField)
	}

Gui, 2:Show,, % "Kopciuszek - Termin " line_count-1 " z " total_lines  " (" dump_file_name ")"
return
;### tu ko�czy si� trzon wielkiego interfejsu
	
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


GuiClose(2):

Gui, 2:Destroy
ExitApp


;==========================================================================
;==========================================================================
;==========================================================================
;=============================== lista p�ac ===============================
;==========================================================================
;==========================================================================
;==========================================================================


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
	if delim = CSV
		{
		For i in array
			{
			if RegExMatch(array[A_Index], "[,;]")
				listarr .= """" array[A_Index] ""","
			else
				listarr .= array[A_Index] ","
			}
		return RTrim(listarr, ",")
		}	
	else
		{
		For i in array
			listarr .= array[i]delim
		return RTrim(listarr, delim)
		}
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


;=== funkcja, kt�ra czyta parametr Case Sensitivity terminu i powoduje zaznaczenie przycisku radio przy odpowiednim terminie (chwilowo niepotrzebna, bo nie mo�na zwraca� przypisa�, wi�c wykonywana jest na piechot�)
Case_Radio_Check(Term_Info, item_ordin)
{
	if InStr(Term_Info, "CaseSense")
		return Sens%item_ordin% := "Checked"
	if InStr(Term_Info, "CasePermissive")
		return Perm%item_ordin% := "Checked"
	if InStr(Term_Info, "CaseInsense")
		return Ins%item_ordin% := "Checked"
}


;=== funkcja do tworzenia pliku do segregacji powi�zanego z przyciskiem ===
Button_Create_Termbase(button_num)
{
global dump_target_path, default_input, dump_lang_prefix, line_one, lista_termbaz
default_input = %dump_lang_prefix% nazwa dumpa.csv
	Loop
		{
		InputBox, ButtonTermbase%button_num%, Tworzenie termbazy docelowej - przycisk %button_num%, Podaj nazw� termbazy`, do kt�rej ma odsy�a� ten przycisk.`nNie zmieniaj kodu j�zyka ani rozszerzenia pliku!`n`nPlik zostanie utworzony w tej samej lokalizacji`, gdzie znajduje si� �r�d�owy plik dump.,,,,,,,, %default_input%
			
		if ErrorLevel
			{
			ButtonTermbase%button_num% := ""
				return

			}
		
		if ButtonTermbase%button_num% = %dump_lang_prefix% nazwa dumpa.csv
			{
			MsgBox, 48, Nieprawid�owa nazwa pliku!, Zmie� domy�ln� nazw� na inn�
			ButtonTermbase%button_num% := 
				continue
			}
		else if not RegExMatch(ButtonTermbase%button_num%, "^" dump_lang_prefix " .*\.csv$")
			{
			MsgBox, 48, Nieprawid�owa nazwa pliku!, Zachowaj kod j�zyka ze spacj� i rozszerzenie.`nNie usuwaj spacji po kodzie j�zyka
;			default_input := ButtonTermbase%button_num% (o ile warto zachowa� w pami�ci nieudany wpis u�ytkownika)
			ButtonTermbase%button_num% := 
				continue
			}
		} until not (ButtonTermbase%button_num% = "")
	
	nazwa_pliku_pod_przyciskiem := ButtonTermbase%button_num%
;	MsgBox % "nazwa przysz�ego nowego pliku to " nazwa_pliku_pod_przyciskiem "`nNazwa ca�ej �cie�ki:`n" dump_target_path "\" nazwa_pliku_pod_przyciskiem
	FileAppend, % line_one "`n", % dump_target_path nazwa_pliku_pod_przyciskiem, UTF-8
	if ErrorLevel
		{
		MsgBox, 48, Nie uda�o si� utworzy� pliku, % "Kod b��du: " A_LastError "`nNie utworzono pliku " dump_target_path nazwa_pliku_pod_przyciskiem "."
;				return
		}
	else
		{
		MsgBox % "Z powodzeniem utworzono plik o nazwie " ButtonTermbase%button_num%
		nazwa_nowej_termbazy := ButtonTermbase%button_num%
		return nazwa_nowej_termbazy
		}
}



;funkcja do tworzenia pliku konfiguracyjnego .ini
CreateIniFile(inicontent, filename:=False)
{
SetWorkingDir %A_ScriptDir%
if filename = 0
	{
	StringTrimRight, filename, A_ScriptName, 4
	}
if !FileExist(filename ".ini")
	{
	FileAppend, %inicontent%, % filename ".ini"
	if ErrorLevel
		MsgBox, 48,, Nie uda�o si� utworzy� pliku pomocniczego. Bez niego zapisanie ustawie� programu nie b�dzie mo�liwe. Mo�na jednak bezpiecznie kontynuowa� prac�.
;	else
;		MsgBox, 48,, Utworzono plik konfiguracyjny %filename%.ini.`nMo�na tam okre�la� nazwy plik�w docelowych dump�w.`nDobrej zabawy!
;	Run, % filename ".ini"
	return
	}
}

; poni�ej funkcja, kt�ra podmienia ��dany element w tablicy
ReplaceArrayItem(array_name, position, new_content)
{
array_name.RemoveAt(position)
array_name.InsertAt(position, new_content)
}


