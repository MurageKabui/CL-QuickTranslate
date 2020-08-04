

<p align="center">
  <img src="https://github.com/KabueMurage/CL-QuickTranslate/blob/master/src/img/logo.jpeg?raw=true" alt=""/>
</p>

  # CL-QuickTranslate

  *As present, you may have noticed that the Web version of Google Translate opens with standard European language pairs by default
  (none of which you may EVER use) , neither nowhere in the [Langauges menu](https://translate.google.com) is there the possibility to set default
  pair languages for translation , nor are the last used pairs synced to your account, which leaves you with the boring alternative to navigate and select the
  them from the drop-down menu or bookmark their [syntax appended url](https://translate.google.com/?langpair=en%7sw) for quick future use. 
  And as a frequent user it might be a bit more painful to keep changing them.*
  
 </div>
 
 |Parameter|Function|Example|
 |--|--|--|
 |-s|Defines a string input.|`Qtranslate.exe -s 'hello world'`|
 -l|Sets a langauge. The Source langauge is will be auto detected.|`Qtranslate.exe -s 'hello world' -l 'swahili' ` |
 -f|Define a file input, |`Qtranslate.exe -f 'noche oscura.txt' -l 'swahili' `|
 
 
For the ```-l``` switch , all standards are backward compatible and fall back to the recognised language ISO prefix officially used by the Google API url,
meaning that the command: ```CL-QuickTranslate.exe -s 'Noche Oscura' -l 'English'``` (Using a native name) would be the same as running : ```CL-QuickTranslate.exe -s 'Noche Oscura' -l 'En'``` (Using the ISO 639-1/T prefix)  and also the same as running:  ```CL-QuickTranslate.exe -s 'Noche Oscura' -l 'En'```  (Using the ISO 639-2/T prefix) <br>


### Support.

Some result output may contain non ASCII characters causing you to see small boxes ▯ ("tofu character") or question marks at the CLI and parsed file 
handles, in this case you are missing corresponding fonts for that writing system.

### Supported languages : 
Currently supported ISO 639 standardized nomenclature cheatsheet.
These can be used with the ```-l``` switch to set the result language for translation. <br>

Example : <br>

<details>
 
  <summary> ISO codes cheat sheet [Click to reveal hidden contents.] </summary>
  
  > The list below shows the currently implimented ISO ids, sorted alphabetically by language, which may be used
  > with the ```-l``` switch to set the result language identity for translation.

|--|ISO language name | *[ISO 639-1](https://en.wikipedia.org/wiki/ISO_639-1)*| *[ISO 639-2/T](https://en.wikipedia.org/wiki/ISO_639-2)*|*[ISO 639-2/B](https://en.wikipedia.org/wiki/ISO_639-2)*|
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
|64|Zulu|*zu*|*zul*|zul|


</details>


### Examples and Snippets:
```batch
 CL-translate.exe -s 'hello world' -l 'german'
 ```
 
###
