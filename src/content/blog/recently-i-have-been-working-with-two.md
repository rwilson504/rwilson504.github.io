---
title: ""
description: "Recently I have been working with two plugins in my web pages. DirtyForm, which allows you to detect when changes have been made to fields, and JQueryUI which has a very flexible popup calendar for…"
pubDate: 2014-04-30
updatedDate: 2014-05-13
category: power-apps
tags:
  - "javascript"
draft: false
originalBloggerUrl: /2014/04/recently-i-have-been-working-with-two.html
---

Recently I have been working with two plugins in my web pages.
DirtyForm, which allows you to detect when changes have been made to fields, and JQueryUI which has a very flexible popup calendar for date fields. One issue i have been having is that the Datepicker does not call the blur even when it's closed which means the DirtyForm plugin doesn't pick up the change. In order to fix this issue I added an onClose handler to my DatePicker selector.
$(".date").datepicker({
changeYear: true,
changeMonth: true,
yearRange: '-100:+10',
minDate: new Date('1900/01/01'),
onClose: function (dateText, datePickerInstance) {
//this will ensure that the dirty\_form plugin will see changes
//when the date is updated
var oldValue = $(this).data('oldValue') || "";
if (dateText !== oldValue) {
$(this).triggerHandler('blur.dirty\_form');
}
}
});
DirtyForm: <https://github.com/acvwilson/dirty_form>
  
Datepicker: <http://jqueryui.com/datepicker/>
  
  
Update 2014/05/13:
I changed from using trigger to triggerHandler as the latter does not re-open the calendar control but still has the same functionality of calling the dirty form handler.
