# Install h2m npm package
#npm install h2m -g
# Here is how to conver html to markdown using h2m
# h2m test.html > test.md

# Run the following one liner converted all HTML files to markdown
#for h in `ls -1 *.html`;do echo $h; m=$(echo $h | sed s/\.html//g).md; h2m $h > $m;  ;done

Get-ChildItem -File | Where-Object {! $_.PSIsContainer -AND $_.Extension -Match "^.html"} | ForEach-Object {
    $finalName = $_.BaseName + ".md"
    h2m -f $_.Name > $finalName
}

#foreach ($file in $files){
    #h2m -f $file.Name > "${$file.BaseName}.md"
    #$file.Name
#}

