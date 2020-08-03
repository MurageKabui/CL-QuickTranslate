# CL-QuickTranslate

> *As present, you may have noticed that the Web version of Google Translate opens with standard European language pairs by default
  (none of which I EVER use) , yet nowhere in the Google menu is there the possibility to set default languages for translation, neither 
  are the last used pairs synced to my account, which leaves me with the boring option to navigate and select the
  languages from the drop-down menu or bookmark their [syntax appended url](https://translate.google.com/?langpair=en%7sw) for quick and future use. 
  And as a frequent user it might be a bit more painful to keep changing them, which led me to a quicker approach to provide
  a one liner solution to it.*
  
《》
Is a google aided translator 
string and files support 
The ```-l``` switch supports the full language iso name or the [ISO 639-1](https://en.wikipedia.org/wiki/ISO_639-1) prefix

### Supported languages : 
Currently supported ISO 639 standardized nomenclature cheatsheet.
These can be used with the ```-l``` switch to set the result language for translation. <br>

Example : Using a full name :<br>
          ```CL-QuickTranslate.exe -s 'Noche Oscura' -l 'English'``` <br>
          ... would be the same as running: <br> 
          ```CL-QuickTranslate.exe -s 'Noche Oscura' -l 'En'     ```  ...(Using the ISO 639-2/T prefix) <br>
          ... or also the same as running: <br>
          ```CL-QuickTranslate.exe -s 'Noche Oscura' -l 'En'     ```  ...(Using the ISO 639-2/T prefix) <br>
<details>
 
  <summary>See full list.</summary>
  
||ISO language name | *[ISO 639-1](https://en.wikipedia.org/wiki/ISO_639-1)*| *[ISO 639-2/T](https://en.wikipedia.org/wiki/ISO_639-2)*|*[ISO 639-2/B](https://en.wikipedia.org/wiki/ISO_639-2)*|
|--|--|--|--|--|
|1|English | *en*||
|2|Afrikaans| *af*|*afr*|afr|
|3|Albanian|*sq*|*sqi*|alb|
|4|Amharic|*am*|*amh*|amh|
|5|Arabic|*ar*|*ara*|ara|
|6|Armenian|*hy*|*hye*|arm|
|7|Azerbaijani|*az*|*aze*|aze|
|8|Basque|*eu*|*eus*|baq|
|9|Belarusian|*be*|*bel*|bel|
|10|Bengali|*bn*|*ben*|ben|
  
</details>


### Examples:
```batch
 CL-translate.exe -s 'hello world' -l 'german'
 ```
 
###
