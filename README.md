

<p align="center">
  <img src="https://github.com/KabueMurage/CL-QuickTranslate/blob/master/giffy.gif?raw=true" alt=""/>
</p>

  # CL-QuickTranslate

  *As present, you may have noticed that the Web version of Google Translate opens with standard European language pairs by default
  (none of which you may EVER use) , neither nowhere in the [Google menu](https://translate.google.com) is there the possibility to set default
  languages for translation nor are the last used pairs synced to my account, which leaves you with the boring alternative to navigate and select the
  languages from the drop-down menu or bookmark their [syntax appended url](https://translate.google.com/?langpair=en%7sw) for quick future use. 
  And as a frequent user it might be a bit more painful to keep changing them, which led me to a quicker approach to provide
  a one liner solution to it.*
 </div>
 
《》
For the ```-l``` switch , all standards are backward compatible and fall back to the recognised language ISO prefix officially used by the Google API url,
meaning that the command: ```CL-QuickTranslate.exe -s 'Noche Oscura' -l 'English'``` (Using a native name) would be the same as running : ```CL-QuickTranslate.exe -s 'Noche Oscura' -l 'En'``` (Using the ISO 639-1/T prefix)  and also the same as running:  ```CL-QuickTranslate.exe -s 'Noche Oscura' -l 'En'```  (Using the ISO 639-2/T prefix) <br>

The ```-l``` switch supports the full language iso name or the [ISO 639-1](https://en.wikipedia.org/wiki/ISO_639-1) prefix

### Supported languages : 
Currently supported ISO 639 standardized nomenclature cheatsheet.
These can be used with the ```-l``` switch to set the result language for translation. <br>

Example : <br>

<details>
 
  <summary> Implimented ISO codes cheat sheet (Reveal hidden contents.) </summary>
  
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
|7|Azerbaijani|*az*|*aze*||
|8|Basque|*eu*|*eus*|baq|
|9|Belarusian|*be*|*bel*|bel|
|10|Bengali|*bn*|*ben*|ben|
|11|Bosnian|*bs*|*bos*|bos|
|12|Bulgarian|*bg*|bul|bul|
|13|Catalan,Valencian|*ca*|*cat*|cat|
|14|Cebuano|*ceb*|||
|15|Chichewa|*ny*|*nya*|nya|
|16|Corsican|*co*|*cos*|cos|
|17|Croatian|*hr*|*hrv*|hrv|
|18|czech|*cs*|*ces*|cze|ces|
|19|Danish|*da*|*dan*|dan|dan|
|20|Dutch, Flemish|*nl*|*nld*|dut|
|21|Esperanto|*eo*|*epo*|epo|
|22|Estonian|*et*|est|est|
|23|Filipino|*tl*|||
|24|Finnish|*fi*|*fin*|fin|
|25|french|*fr*|*fra*|fre|
|26|Frisian|*fy*|*fry*||

  
</details>


### Examples:
```batch
 CL-translate.exe -s 'hello world' -l 'german'
 ```
 
###
