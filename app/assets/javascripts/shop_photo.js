// Noimage画像を表示させる
window.addEventListener("load", function(){
  let preview = document.getElementById("preview");
  let previewImage = document.getElementById("previewImage");
  let defalutimg = document.getElementById("defalutimg");
  if(previewImage == null) {
    preview.style.display = "none";
    defalutimg.style.display = "block";
  }
})

// アップロードした画像を表示
function imgPreView(event){
  let file = event.target.files[0];
  let reader = new FileReader();
  let preview = document.getElementById("preview");
  let inputFile = document.getElementById("photo");
  let previewImage = document.getElementById("previewImage");
  if(previewImage != null) {
    preview.removeChild(previewImage);
  }
  reader.onload = function(event) {
    let img = document.createElement("img");
    img.setAttribute("src", reader.result);
    img.setAttribute("id", "previewImage");
    preview.appendChild(img);
  };
  setTimeout(() => {
    if (inputFile.value.length) {
      reader.readAsDataURL(file);
      preview.style.display = "block";
      defalutimg.style.display = "none";
    } else {
      preview.style.display = "none";
      defalutimg.style.display = "block";
    }
  }, 500);
}



