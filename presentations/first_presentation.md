<!-- 
	MARP SLIDE TEMPLATES
	--
	Written for: 	[Marp](https://yhatt.github.io/marp/)
	Written for:	Version 0.0.12
	--
	Written by:		[Stousn](https://github.com/stousn)
	Licence:		[MIT Licence]()
-->

<!-- Basic Setup -->
<!-- $size: 16:9 -->
<!-- page_number: false -->

<!-- choose between default and gaia -->
<!-- $theme: gaia -->

<!-- choose between default, gaia and inverted -->
<!-- template: gaia -->

<!-- For Background uncomment one of the following lines 
	 and copy it for each slide -->
<!--![bg](bg.jpg)-->
<!--![bg](bg1.jpg)-->
<!--![bg](bg2.jpg)-->
<!--![bg](bg3.jpg)-->
<!--![bg original](bg3.jpg)-->
<!--![bg](bg4.jpg)-->
<!--![bg](bg5.jpg)-->
<!--![bg](bg6.jpg)-->
<!--![bg](bg7.jpg)-->

# Face ==2== Screen Distance
##### Modify sizes on Smartphone dependant of distance to face
###### ==Stefan Reip==

---
<!-- page_number: true -->
<!-- footer: NaMoApps: First Presentation - Reip -->

## ==1.== Problem
* Kurzer Blick auf das Gerät
* Visuelle Beeinträchtigung
	* "ohne Brille"
* Viele kleine (unwichtige) Infos
---

## ==2.== Idee
* Wenn das Device weiter entfert ist
	* Wenig Details
	* Das Wesentliche anzeigen
* Wenn das Device nah am Gesicht ist
	* Höherer Detailgrad
	* Kleinere Texte / Grafiken

__=> Umsetzung am Beispiel einer Wetter-App__ 

---

## ==3.== Ergebnis
<table>
  <tr>
    <td rowspan="3">Muss:</td>
    <td>Wetter-App auf Basis GPS & Suche</td>
  </tr>
  <tr>
    <td>API für Wetter anbinden</td>
  </tr>
  <tr>
    <td>Adaptive Anzeige (ggf. auf Break Point Basis)
  </tr>
    <tr>
    <td rowspan="3">Kann:</td>
    <td>Watch App (Zoom mit Digital Crown)</td>
  </tr>
  <tr>
    <td>A11Y-Richtlinien konform</td>
  </tr>
  <tr>
    <td>Notifications</td>
  </tr>
</table>

---
### ==4.== Personas
* Heribert (65), weitsichtig
	* Sieht Details der Apps oft nicht gut
	* Hat sich extra ein iPhone 8 Plus gekauft (größeres Display)
* Susanne (32), kurzsichtig
	* Liegt oft ohne Brille mit dem Smartphone im Bett
* Luca, (22), iPhone SE User
	* Will alle wichtigen Informationen auf einen Blick sehen, auch am kleinen Screen
---
### ==5.== User Story
#### ==Als== Susanne
#### ==möchte ich== auch ohne Brille im Bett die aktuelle Außentemperatur ablesen können,
#### ==damit ich== weiß, ob ich einen Pullover brauche, wenn ich das Haus verlasse
<span></span>

---
### ==6.== UI-Prototyp
<span></span>

---
### ==7.== Nächste Schritte
* Funktionierende Wetter App
	* UI Implementierung
	* Anbindung API
	* GPS-Daten auslesen
* Größen-Änderung
	* UI für gezoomte Anzeige anpassbar machen
	* Entfernung auslesen

---

<!-- *footer: -->

# Face ==2== Screen Distance
##### Modify sizes on Smartphone dependant of distance to face
###### ==Stefan Reip==

