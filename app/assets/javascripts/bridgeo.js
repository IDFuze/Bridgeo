function loadExtJs(filename, callback) {
  var f=document.createElement("script");
  f.setAttribute("type","text/javascript");
  f.setAttribute("src", filename);
  if (f.readyState){  //IE
    f.onreadystatechange = function(){
      if (f.readyState == "loaded" || f.readyState == "complete"){
        f.onreadystatechange = null;
        callback();
      }
    };
  } else {  //Others
    f.onload = function() { callback(); };
  }
 document.getElementsByTagName("head")[0].appendChild(f)
}

var checkLibs = function() {
  // Load jQuery and underscore.js & mustache.js
  loadExtJs("/assets/jquery.js", function() {
    loadExtJs("/assets/underscore.js", function() {
      loadExtJs("/assets/mustache.js", function() {
        $.get("/home/loadlayout");
      });
    });
  });    
}

window.onload = checkLibs();

