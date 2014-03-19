$(document).ready(function(){
  $("span.label:contains('MT')").addClass("label-mt");
  $("span.label:contains('UT')").addClass("label-ut");
  $("span.label:contains('RT')").addClass("label-rt");
  $("span.label:contains('ET')").addClass("label-et");
  $("span.label:contains('PT')").addClass("label-important");
  $("span.label:contains('VT')").addClass("label-vt");
  $("span.label:contains('DT')").addClass("label-dt");

  $(".chosen-select").chosen();

});