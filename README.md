

<p align="center">
  <img src="https://github.com/KabueMurage/CL-QuickTranslate/blob/master/src/img/logo.jpeg?raw=true" alt=""/>
</p>

  # CL-QuickTranslate
  
 <img src="https://github.com/KabueMurage/CL-QuickTranslate/blob/master/src/img/logo.jpg?raw=true" align="left" alt="">
  
  
  *As present, you may have noticed that the Web version of Google Translate opens with standard European language pairs by default
  (none of which you may EVER use) , neither nowhere in the [Languages menu](https://translate.google.com) is there the possibility to set default
  pair languages for translation , nor are the last used pairs synced to your account, which leaves you with the boring alternative to navigate and select
  them from the drop-down menu or bookmark their [syntax appended url](https://translate.google.com/?langpair=en%7sw) for quick future use , and as a frequent user it might be a bit more painful to keep changing them.*
  
 
  To save time, this program offers a quick solution to use one liners to achieve the same goal , and with the possibility to fully automate the process
  using batch scrips or any desired programming / scripting  language, quite handy when you want to translate simple words/sentences and file contents to 
  any desired language. <br>
  
  
  ### Installation
  Download and add to [path](https://en.wikipedia.org/wiki/PATH_%28variable%29).  Running ``Qtranslate.exe -v`` should print the current version number.

### Syntax and Usage:
 
 |Parameter|Function|Example|
 |--|--|--|
 |-s| Define a string input.|`Qtranslate.exe -s 'hello world'`|
 |-l|Sets a language. The Source language is will be auto detected.|`Qtranslate.exe -s 'hello world' -l 'swahili' ` |
 |-o| Optional parameter to parse the translated text to a file handle to avoid wrongly rendering non-ascii characters to the CLI.  The translated text is printed to the standard output by default. |`Qtranslate.exe -f 'En-EULA.rtf' -l 'ru' -o "Russian_EULA.txt"`|
 |-f|Define a file input. The Supported filetypes are: <br> *.txt*, *.lrc*, *.rtf*, *.md*, *.ini*|`Qtranslate.exe -f 'Noche Oscura.txt' -l 'English' >> "En_NocheOscura.txt"`|
 |-ver<br> -version <br> -v|Print the version number. |`Qtranslate.exe -ver`|
 |/debug|If you're unsure about any response or errors you can use this flag to print all the behind the scene events. <br> This parameter does not require an argument.|`Qtranslate.exe -s "hello world" -l sw /debug`| 

<br>

  ### Demo
<p align="center">
  <img src="https://github.com/KabueMurage/CL-QuickTranslate/blob/master/src/img/demo.gif?raw=true" alt=""/>
</p>

> Translating Files Demo : <br> ```QTranslate.exe -f "My Discord Server Rules.txt" -l "french" >> Fr_DiscordRules.txt```

<br>

For the ```-l``` switch , all standards are backward compatible and fall back to the ISO 639-1 language prefix which is normally used by the Google Translate API ,
meaning that the command: ```Qtranslate.exe -s 'Noche Oscura' -l 'Albanian'``` (Using a native name) would be the same as running : ```Qtranslate.exe -s 'Noche Oscura' -l 'sq'``` (Using the ISO 639-1 prefix) , also the same as running:  ```Qtranslate.exe -s 'Noche Oscura' -l 'sqi'```  (Using the ISO 639-2/T prefix)  and  also the same as ```Qtranslate.exe -s 'Noche Oscura' -l 'alb'```  (Using the ISO 639-2/B prefix) <br>

<details>
 
  <summary> Some ISO codes cheat sheet [Click to reveal hidden contents.] </summary>
  
  >  All languages standard may be used with the ```-l``` switch to set the destination language for translation.
  >  The source language is auto detected by default.
  > see full list at :https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwixuKmY9_LrAhVFCxoKHUgsB1kQFjAAegQIAxAB&url=https%3A%2F%2Fcloud.google.com%2Ftranslate%2Fdocs%2Flanguages&usg=AOvVaw0DS2aRvqlazR86JXJI1fsn
  
||ISO language name | *[ISO 639-1](https://en.wikipedia.org/wiki/ISO_639-1)*| *[ISO 639-2/T](https://en.wikipedia.org/wiki/ISO_639-2)*|*[ISO 639-2/B](https://en.wikipedia.org/wiki/ISO_639-2)*|
|--|--|--|--|--|
|1|English |*en*|*eng*|eng|
|2|Afrikaans|*af*|*afr*|afr|
|3|Albanian|*sq*|*sqi*|alb|
|4|Amharic|*am*|*amh*|amh|
|5|Arabic|*ar*|*ara*|ara|
|6|Armenian|*hy*|*hye*|arm|
|7|Azerbaijani|*az*|*aze*|-|
|8|Basque|*eu*|*eus*|baq|
|9|Belarusian|*be*|*bel*|bel|
|10|Bengali|*bn*|*ben*|ben|
|11|Bosnian|*bs*|*bos*|bos|
|12|Bulgarian|*bg*|bul|bul|
|13|Catalan,Valencian|*ca*|*cat*|cat|
|14|Cebuano|*ceb*|ceb|ceb|
|15|Chichewa|*ny*|*nya*|nya|
|16|Corsican|*co*|*cos*|cos|
|17|Croatian|*hr*|*hrv*|hrv|
|18|czech|*cs*|*ces*|cze|ces|
|19|Danish|*da*|*dan*|dan|dan|
|20|Dutch, Flemish|*nl*|*nld*|dut|
|21|Esperanto|*eo*|*epo*|epo|
|22|Estonian|*et*|est|est|
|23|Filipino|*tl*|tl|tl|
|24|Finnish|*fi*|*fin*|fin|
|25|french|*fr*|*fra*|fre|
|26|Frisian|*fy*|*fry*|fry|
|27|Georgian|*gl*|*glg*|glg|
|28|German|*de*|*deu*|ger|
|29|Haitian,Haitian Creole|*ht*|*hat*|hat|
|30|Hausa|*ha*|*hau*|hau|
|31|Hawaiian|*haw*|haw|haw|
|32|Hmong|*hmn*|hmn|hmn|
|33|Hungarian|*hu*|hun|hun|
|34|Icelandic|*is*|*isl*|ice|
|35|Igbo|*ig*|*ibo*|ibo|
|36|Indonesian|*id*|*ind*|ind|
|37|Irish|*ga*|*gle*|gle|
|38|Italian|*it*|ita|ita|
|39|Khmer|*km*|*km*|km|
|40|Latin|*la*|*lat*|lat|lat|
|41|Latvian|*lv*|*lav*|lav|
|42|Lithuanian|*lt*|*lit*|lit|
|43|Luxembourgish|*lb*|*ltz*|ltz|
|44|Malagasy|*mg*|*mlg*|mlg|
|45|Malay|*ms*|*msa*|msa|
|46|Maltese|*mt*|*mlt*|mlt|
|47|Maori|*mi*|*mri*|mao|
|48|Norwegian|*no*|*nor*|nor|
|49|Polish|*pl*|*pol*|pol|
|50|Portuguese|*pt*|*por*|por|
|51|Romanian,moldavian|*ro*|*ron*|rum|
|52|Sesotho|*st*|*sot*|sot|
|53|Slovak|*sk*|*slk*|slk|
|54|Slovenian|*sl*|*slv*|slv|
|55|Somali|*so*|*som*|som|
|56|Spanish,Castilian|*es*|*spa*|spa|
|57|Swahili, Kiswahili|*sw*|*swa*|swa|
|58|Swedish|*sv*|*swe*|swe|
|59|Turkish|*tr*|*tur*|tur|
|60|Uzbek|*uz*|*uzb*|uzb|
|61|Vietnamese|*vi*|*vie*|vie|
|62|Welsh|*cy*|*cym*|wel|
|63|Xhosa|*xh*|*xho*|xho|
|64|Yoruba|*yo*|yor|yor|
|65|Zulu|*zu*|*zul*|zul|
...

</details>

[Project Board](https://github.com/users/KabueMurage/projects/4)

###
