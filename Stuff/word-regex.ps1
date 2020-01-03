$searchStr = "CIS\/[0-9]{4}\/N\/[0-9]{3}"
$isRegexp = $true
$files = gci -path "g:\spc","h:\spc" -include "*.doc*","*.tp?" -recurse 

$default = [Type]::Missing
$word = new-object -ComObject "word.application"
foreach ($file in $files) {

   $doc = $word.documents.open($file.fullname, )
   # expression.Execute(FindText, MatchCase, MatchWholeWord, MatchWildcards, 
   #  MatchSoundsLike, MatchAllWordForms, Forward, Wrap, Format, ReplaceWith, 
   #  Replace, MatchKashida, MatchDiacritics, MatchAlefHamza, MatchControl)
   if ($doc.content.find.execute($searchStr,$default,$default,$isRegexp)) {

      echo $file.fullname
   }
   $doc.close()
}