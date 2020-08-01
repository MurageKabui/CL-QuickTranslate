
Is a google aided translator 
string and files support 

</details>

## About

  <summary> 《 About QTranslate 》</summary>
  
  *As present, you may have noticed that the Web version of Google Translate opens with standard European language pairs by default
  (none of which I EVER use) , yet nowhere in the Google menu is there the possibility to set default languages for translation, neither 
  are the last used pairs synced to my account, which leaves me with the boring option to navigate the
  languages from the drop-down menu or bookmark their syntax appended url for quick and future use. 
  And as a frequent user it might be a bit more painful to keep changing them, which led me to a quicker approach to provide
  a one liner solution to it.*

<details>
  
  <summary> 《 idk 》</summary>
  <p> hello world.</p>
</details>


The ```-l``` switch supports the full language iso name or the [ISO 639-1](https://en.wikipedia.org/wiki/ISO_639-1) prefix


### Example using a string ``-s``:
> ```CL-translate.exe -s 'hello world' -l 'german'```

 ### **Example using a file ```-f```:**
> ```CL-translate.exe -f "Noche Oscura.txt" -l English```

# A collapsible section containing code
<details>

  <summary>List for all the supported languages</summary>

||ISO language name | *[ISO 639-1](https://en.wikipedia.org/wiki/ISO_639-1)*| d|
|--|--|--|--|
|1|English | *en*|
|2|Vietnamese| *vi*|
|3|Turkish||
|4|Swedish||
|5|Russian||
|6|Portuguese||

  
</details>

## Research Source
<details>
  <summary>Click to expand!</summary>
  
  > Here are some of the good old.
  > jodnfdnfdkn issds
  1. [How Google Translate works](https://www.independent.co.uk/life-style/gadgets-and-tech/news/google-translate-how-work-foreign-languages-interpreter-app-search-engine-a8406131.html)
  2. list
     * With some
     * Sub bullets
     
</details>

# A collapsible section containing code

<details>
  
  <summary>Batch snippet Examples. (Click to expand!)</summary>
  
  ```batch
	  set "lang = swahili"
	  for /f "tokens=1,2 delims=." %%a in ('dir /b .txt') do (CL-translator.exe -l %lang% %a
  ```
</details>

#
