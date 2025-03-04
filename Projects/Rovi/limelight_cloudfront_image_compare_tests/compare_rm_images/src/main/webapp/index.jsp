<!DOCTYPE html>
<html lang="en">

<head>
<!-- jquery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js"></script>

<link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.11/themes/ui-lightness/jquery-ui.css" type="text/css" media="all" />

<script src="https://www.google.com/jsapi" type="text/javascript"></script>
<link rel="stylesheet" href="stylesheet.css" type="text/css">


<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">

<!-- Optional theme -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">

<!-- Latest compiled and minified JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>

</head>

<script type="text/javascript">
var URLs, result, cpsHeight, cpsWidth, cfHeight, cfWidth;
var count = 0;

//Get JSON data on Window load
window.onload = function(){
	console.log("getting urls");
	httpGet("http://localhost:8082/image/get");
	URLs =JSON.parse(result);
	next();
};


//CORS configuration to allow cross-domain access
function createCORSRequest(method, url) {
  var xhr = new XMLHttpRequest();
  if ("withCredentials" in xhr) {
    xhr.open(method, url, false);
  } else if (typeof XDomainRequest != "undefined") {
    xhr = new XDomainRequest();
    xhr.open(method, url);
  } else {
    xhr = null;
  }
  return xhr;
}
function httpGet(theUrl)
{
	var xhr = createCORSRequest('GET',theUrl);
	if(xhr){
			xhr.onload = function(){
				result = xhr.responseText;
			}
	}
	xhr.send(null);
}


//Update URLs on the webpage
function updateURL(){
	document.getElementById('cps_urls').innerHTML = URLs.result.CPS[count].URL;
	document.getElementById('cf_urls').innerHTML = URLs.result.CF[count].URL;
}


//Delete existing images on the page
function deleteOldImage(){
	var cpsImage = document.getElementById('cpsImagediv');
	var cloudFrontImage = document.getElementById('cfImagediv');
	while (cpsImage.firstChild){cpsImage.removeChild(cpsImage.firstChild);}
	while (cloudFrontImage.firstChild){cloudFrontImage.removeChild(cloudFrontImage.firstChild);}
}

//Delete images that were loaded to obtain original dimensions
function deleteDimensionData(){
	var dcpsImage = document.getElementById('cpsdimension');
	var dcloudFrontImage = document.getElementById('cfdimension');
	while (dcpsImage.firstChild){dcpsImage.removeChild(dcpsImage.firstChild);}
	while (dcloudFrontImage.firstChild){dcloudFrontImage.removeChild(dcloudFrontImage.firstChild);}
}

//Delete Metadata
function deleteOldMetaData(){
	var cpsMetaData = document.getElementById('cps_metadata');
	var cfMetaData = document.getElementById('cf_metadata');
	while (cpsMetaData.firstChild){cpsMetaData.removeChild(cpsMetaData.firstChild);}
	while (cfMetaData.firstChild){cfMetaData.removeChild(cfMetaData.firstChild);}
}


//Load the original image, obtain actual dimensions from it and then delete it
function obtainDimensions(){

	var img = new Image();
	var img2 = new Image();
	img.onload = function(){
		img2.onload = function(){
			cpsHeight = document.getElementById('dcpsAppendedImages').clientHeight;
			cpsWidth  = document.getElementById('dcpsAppendedImages').clientWidth;
	
			cfHeight = document.getElementById('dcfAppendedImages').clientHeight;
			cfWidth  = document.getElementById('dcfAppendedImages').clientWidth;
			
			setTimeout(function(){
			deleteDimensionData();
			},1);
		}
	}
	
	img.src = URLs.result.CPS[count].URL;
	img.id = "dcpsAppendedImages";

	img2.src = URLs.result.CF[count].URL;
	img2.id = "dcfAppendedImages";	
	
	document.getElementById('cpsdimension').appendChild(img);
	document.getElementById('cfdimension').appendChild(img2);
}

//View next image
function next(){
	count = count + 10;
	console.log("next: "+count);

	obtainDimensions();
	deleteOldImage();
	deleteOldMetaData();
	
	setTimeout(function (){
			var cps_img = document.createElement('img');
			cps_img.src = URLs.result.CPS[count].URL;
			cps_img.id = "cpsAppendedImages";
			document.getElementById('cpsImagediv').appendChild(cps_img);
			
			//Setting Timeout to Ensure that the images are loaded before getting the dimensions
			setTimeout(function (){
			var cps_meta  = document.createElement('p');
			cps_meta.id = "image_metadata";
			cps_meta.innerHTML = "Height: <em>"+ cpsHeight+"px</em>"+"</br>"+ "Width: <em>"+ 
						cpsWidth+"px</em>"+"</br>"+"Bytes:"+URLs.result.CPS[count].Bytes +"</br>";

			document.getElementById('cps_metadata').appendChild(cps_meta);
			},100);

			var cf_img = document.createElement('img');
			cf_img.src = URLs.result.CF[count].URL;
			cf_img.id = "cfAppendedImages";
			document.getElementById('cfImagediv').appendChild(cf_img);
			
			setTimeout(function (){
			var cf_meta  = document.createElement('p');
			cf_meta.id = "image_metadata";
			cf_meta.innerHTML = "Height: <em>"+ cfHeight+"px</em>"+"</br>"+ "Width: <em>"+ 
						cfWidth+"px</em>"+"</br>"+"Bytes:"+URLs.result.CF[count].Bytes +"</br>";

			
			document.getElementById('cf_metadata').appendChild(cf_meta);
			},100);
	},90);
		
	setTimeout(function (){		
		updateURL();
	},201);
}

//View Previous image
function previous(){
if(count==0){count = 0}else{count = count - 10;}
	console.log("prev: " +count);
	obtainDimensions();
	deleteOldImage();
	deleteOldMetaData();

			var cps_img = document.createElement('img');
			cps_img.src = URLs.result.CPS[count].URL;
			cps_img.id = "cpsAppendedImages";
			document.getElementById('cpsImagediv').appendChild(cps_img);
			
			//Setting Timeout to Ensure that the images are loaded before getting the dimensions
			setTimeout(function (){
			var cps_meta  = document.createElement('p');
			cps_meta.id = "image_metadata";
			cps_meta.innerHTML = "Height: <em>"+ cpsHeight +"px</em>"+"</br>"+ "Width: <em>"+ cpsWidth+"px</em>"+"</br>"+"Bytes:"+URLs.result.CPS[count].Bytes +"</br>";

			
			document.getElementById('cps_metadata').appendChild(cps_meta);
			},100);

			var cf_img = document.createElement('img');
			cf_img.src = URLs.result.CF[count].URL;
			cf_img.id = "cfAppendedImages";
			document.getElementById('cfImagediv').appendChild(cf_img);
			
			setTimeout(function (){
			var cf_meta  = document.createElement('p');
			cf_meta.id = "image_metadata";
			cf_meta.innerHTML = "Height: <em>"+ cfHeight +"px</em>"+"</br>"+ "Width: <em>"+cfWidth+"px</em>"+"</br>"+"Bytes:"+URLs.result.CF[count].Bytes +"</br>";

			
			document.getElementById('cf_metadata').appendChild(cf_meta);
			},100);
		
		
	setTimeout(function (){		
		updateURL();
	},201);
}
</script>

<body>

<!-- nav -->
<nav id="navbar" class="navbar default" style="width:100%; background:red;"> </nav>

<!--images and metadata-->
<section id="images">
	<!-- data container -->
	<div class="container-fluid">
	
		<div class="col-sm-12" style="width:100%;">
			<div class="col-lg-6 " >
				<p class="lead" id="headers">CPS-STATIC</p>
				<div id="cps_metadata"></div>				
				<div  id="cpsStatic" >
					<p id="cpsImagediv" ></p>
					<p id="cpsdimension"></p>					
				</div>
				<p id="cps_urls"></p>
			</div>
			<div class="col-lg-6 " >
				<p class="lead" id="headers">CLOUD FRONT</p>
				<div  id="cf_metadata"></div>				
				<div  id="cloudFront" >
					<p id="cfImagediv" ></p>
					<p id="cfdimension"></p>
				</div>
				<p id="cf_urls"></p>
			</div>
		</div>
		
	<!-- data container -->	
	</div>
	
<!--images and metadata-->
</section>



<!--buttons-->
<section>
	<div class="col-lg-12">
		<div class="col-lg-6"><button  id="buttons" onclick="previous()">< Previous</button></div>
		<div class="col-lg-6"><button  id="buttons" onclick="next()">Next ></button></div>
	</div>
<section>

</body>


</html>


