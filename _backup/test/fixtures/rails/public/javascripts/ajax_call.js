http = new XMLHttpRequest();
http.open("GET", "/ajax");
http.onreadystatechange=function() {
  if(http.readyState == 4) {
    document.title = 'ajaxed!'
  }
}
http.send(null);