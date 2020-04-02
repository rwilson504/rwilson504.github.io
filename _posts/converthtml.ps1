# Install h2m npm package
#npm install h2m -g
# Here is how to conver html to markdown using h2m
# h2m test.html > test.md

# Run the following one liner converted all HTML files to markdown
#for h in `ls -1 *.html`;do echo $h; m=$(echo $h | sed s/\.html//g).md; h2m $h > $m;  ;done

#convert all files from html to md
Get-ChildItem -File | Where-Object {! $_.PSIsContainer -AND $_.Extension -Match "^.html"} | ForEach-Object {
    $finalName = $_.BaseName + ".md"
    h2m -f $_.Name > $finalName
}

#convert all files to UTF8 Wihtout BOM
Get-ChildItem -File | Where-Object {! $_.PSIsContainer -AND $_.Extension -Match "^.md"} | ForEach-Object {
    $MyRawString = Get-Content -Raw $_.Name
    $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines($_.Name, $MyRawString, $Utf8NoBomEncoding)    
}
