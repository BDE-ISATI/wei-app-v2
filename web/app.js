async function compressAndDownloadImage(base64) {
    var url = base64;

	try {
		var res = await fetch(url);
		var blob = await res.blob();

		var imageFile = blob;
		// console.log(base64);
		console.log('originalFile instanceof Blob', imageFile instanceof Blob); // true
		console.log(`originalFile size ${imageFile.size / 1024 / 1024} MB`);

		var options = {
			maxSizeMB: 0.2,//right now max size is 200kb you can change
			maxWidthOrHeight: 1920,
			useWebWorker: true	
		}
					
		var compressedFile = await imageCompression(imageFile, options);
		
		console.log('compressedFile instanceof Blob', compressedFile instanceof Blob); // true
		console.log(`compressedFile size ${compressedFile.size / 1024 / 1024} MB`); // smaller than maxSizeMB

		var base64blob = await blobToBase64(compressedFile);

		// console.log("base64: " + base64blob);
							
		// return new Blob([compressedFile], { type: "image/jpeg" });
		window.parent.postMessage(base64blob, "*");
 	} catch(error) {
        console.log(error.message);
    }
}

function blobToBase64(blob) {
  return new Promise((resolve, _) => {
    const reader = new FileReader();
    reader.onloadend = () => resolve(reader.result.split(',')[1]);
    reader.readAsDataURL(blob);
  });
}