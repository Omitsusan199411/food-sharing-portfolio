//Noimage画像を表示させる
window.addEventListener("load", function(){
  let aicon = document.getElementById("aicon");
  let aiconImage = document.getElementById("aiconImage");
  let user_defalutimg = document.getElementById("user_defalutimg");
  if(aiconImage == null) {
    aicon.style.display = "none";
    user_defalutimg.style.display = "block";
  }
})

//アップロードした画像を表示
function Aicon(event){
  let file = event.target.files[0];
  let reader = new FileReader();
  let inputFile= document.getElementById("user_photo");
  let aicon = document.getElementById("aicon");
  let aiconImage = document.getElementById("aiconImage");
  if(aiconImage != null) {
    aicon.removeChild(aiconImage);
  }
  reader.onload = function(event) {
    let img = document.createElement("img");
    img.setAttribute("src", reader.result);
    aicon.appendChild(img);
  };
  setTimeout(() => {
    if (inputFile.value.length) {
      reader.readAsDataURL(file);
      aicon.style.display = "block";
      user_defalutimg.style.display = "none";
    } else {
      aicon.style.display = "none";
      user_defalutimg.style.display = "block";
    }
  }, 450);
}